# frozen_string_literal: true

class TimelineEvent < ApplicationRecord
  belongs_to :target
  belongs_to :improved_timeline_event, class_name: 'TimelineEvent', optional: true
  belongs_to :evaluator, class_name: 'Faculty', optional: true

  has_many :target_evaluation_criteria, through: :target
  has_many :evaluation_criteria, through: :target_evaluation_criteria
  has_many :startup_feedback, dependent: :destroy
  has_many :timeline_event_files, dependent: :destroy
  has_one :improvement_of, class_name: 'TimelineEvent', foreign_key: 'improved_timeline_event_id', dependent: :nullify, inverse_of: :improved_timeline_event
  has_many :timeline_event_grades, dependent: :destroy
  has_many :timeline_event_owners, dependent: :destroy
  has_many :founders, through: :timeline_event_owners
  has_one :course, through: :target

  serialize :links

  delegate :founder_event?, to: :target
  delegate :title, to: :target

  MAX_DESCRIPTION_CHARACTERS = 500

  validates :description, presence: true

  scope :from_admitted_startups, -> { joins(:founders).where(founders: { startup: Startup.admitted }) }
  scope :not_private, -> { joins(:target).where.not(targets: { role: Target::ROLE_FOUNDER }) }
  scope :not_improved, -> { joins(:target).where(improved_timeline_event_id: nil) }
  scope :not_auto_verified, -> { joins(:evaluation_criteria).distinct }
  scope :auto_verified, -> { where.not(id: not_auto_verified) }
  scope :passed, -> { where.not(passed_at: nil) }
  scope :pending_review, -> { not_auto_verified.where(evaluator_id: nil) }
  scope :evaluated_by_faculty, -> { where.not(evaluator_id: nil) }
  scope :from_founders, ->(founders) { joins(:timeline_event_owners).where(timeline_event_owners: { founder: founders }) }

  after_initialize :make_links_an_array

  def make_links_an_array
    self.links ||= []
  end

  before_save :ensure_links_is_an_array

  def ensure_links_is_an_array
    self.links = [] if links.nil?
  end

  # Accessors used by timeline builder form to create TimelineEventFile entries.
  # Should contain a hash: { identifier_key => uploaded_file, ... }
  attr_accessor :files

  def reviewed?
    timeline_event_grades.present?
  end

  def public_link?
    links.reject { |l| l[:private] }.present?
  end

  def founder_or_startup
    founder_event? ? founder : startup
  end

  def improved_event_candidates
    founder_or_startup.timeline_events
      .where('created_at > ?', created_at)
      .where.not(id: id).order('created_at DESC')
  end

  def share_url
    Rails.application.routes.url_helpers.student_timeline_event_show_url(
      id: founder.id,
      event_id: id,
      event_title: title.parameterize,
      host: founders.first.school.domains.primary.fqdn
    )
  end

  def overall_grade_from_score
    return if score.blank?

    { 1 => 'good', 2 => 'great', 3 => 'wow' }[score.floor]
  end

  # TODO: Remove TimelineEvent#startup when possible.
  def startup
    first_founder = founders.first

    raise "TimelineEvent##{id} does not have any linked founders" if first_founder.blank?

    # TODO: This is a hack. Remove TimelineEvent#startup method after all of its usages have been deleted.
    first_founder.startup
  end

  def founder
    founders.first
  end

  def passed?
    passed_at.present?
  end

  def team_event?
    target.team_target?
  end

  def pending_review?
    passed_at.blank? && evaluator_id.blank?
  end

  def status
    if passed_at.blank?
      evaluator_id.present? ? :failed : :pending
    else
      evaluator_id.present? ? :passed : :marked_as_complete
    end
  end
end

# frozen_string_literal: true

class Target < ApplicationRecord
  # Use to allow changing visibility of a target. See Targets::UpdateVisibilityService.
  attr_accessor :safe_to_change_visibility

  # Need to allow these two to be read for AA form.
  attr_reader :startup_id, :founder_id

  STATUS_COMPLETE = :complete
  STATUS_NEEDS_IMPROVEMENT = :needs_improvement
  STATUS_SUBMITTED = :submitted
  STATUS_PENDING = :pending
  STATUS_UNAVAILABLE = :unavailable # This handles two cases: targets that are not submittable, and ones with prerequisites pending.
  STATUS_NOT_ACCEPTED = :not_accepted
  STATUS_LEVEL_LOCKED = :level_locked # Target is of a higher level
  STATUS_PENDING_MILESTONE = :pending_milestone # Milestone targets of the previous level are incomplete

  UNSUBMITTABLE_STATUSES = [
    STATUS_UNAVAILABLE,
    STATUS_LEVEL_LOCKED,
    STATUS_PENDING_MILESTONE
  ].freeze

  belongs_to :faculty, optional: true
  has_many :timeline_events, dependent: :restrict_with_error
  has_many :target_prerequisites, dependent: :destroy
  has_many :prerequisite_targets, through: :target_prerequisites
  belongs_to :target_group
  has_many :target_resources, dependent: :destroy
  has_many :resources, through: :target_resources
  has_many :target_evaluation_criteria, dependent: :destroy
  has_many :evaluation_criteria, through: :target_evaluation_criteria
  has_one :level, through: :target_group
  has_one :course, through: :target_group
  has_one :quiz, dependent: :restrict_with_error
  has_many :content_versions, dependent: :destroy
  has_many :target_questions, dependent: :destroy
  has_many :questions, through: :target_questions
  has_many :resource_versions, as: :versionable, dependent: :restrict_with_error

  acts_as_taggable

  scope :live, -> { where(visibility: VISIBILITY_LIVE) }
  scope :founder, -> { where(role: ROLE_FOUNDER) }
  scope :not_founder, -> { where.not(role: ROLE_FOUNDER) }
  scope :sessions, -> { where.not(session_at: nil) }
  scope :not_auto_verifiable, -> { joins(:target_evaluation_criteria).distinct }
  scope :auto_verifiable, -> { where.not(id: not_auto_verifiable) }

  # Custom scope to allow AA to filter by intersection of tags.
  scope :ransack_tagged_with, ->(*tags) { tagged_with(tags) }

  def self.ransackable_scopes(_auth)
    %i[ransack_tagged_with]
  end

  ROLE_FOUNDER = 'founder'
  ROLE_TEAM = 'team'

  # See en.yml's target.role
  def self.valid_roles
    [ROLE_FOUNDER, ROLE_TEAM].freeze
  end

  TYPE_TODO = 'Todo'
  TYPE_ATTEND = 'Attend'
  TYPE_READ = 'Read'
  TYPE_LEARN = 'Learn'

  VISIBILITY_LIVE = 'live'
  VISIBILITY_ARCHIVED = 'archived'
  VISIBILITY_DRAFT = 'draft'

  def self.valid_target_action_types
    [TYPE_TODO, TYPE_ATTEND, TYPE_READ, TYPE_LEARN].freeze
  end

  def self.valid_visibility_types
    [VISIBILITY_LIVE, VISIBILITY_ARCHIVED, VISIBILITY_DRAFT].freeze
  end

  validates :target_action_type, inclusion: { in: valid_target_action_types }, allow_nil: true
  validates :role, presence: true, inclusion: { in: valid_roles }
  validates :title, presence: true
  validates :call_to_action, length: { maximum: 20 }
  validates :visibility, inclusion: { in: valid_visibility_types }, allow_nil: true

  validate :days_to_complete_or_session_at_should_be_present

  def days_to_complete_or_session_at_should_be_present
    return if days_to_complete.blank? && session_at.blank?
    return if [days_to_complete, session_at].one?

    errors[:base] << 'One of days_to_complete, or session_at should be set.'
    errors[:days_to_complete] << 'if blank, session_at should be set'
    errors[:session_at] << 'if blank, days_to_complete should be set'
  end

  validate :avoid_level_mismatch_with_group

  def avoid_level_mismatch_with_group
    return if target_group.blank? || level.blank?
    return if level == target_group.level

    errors[:level] << 'should match level of target group'
  end

  validate :must_be_safe_to_change_visibility

  def must_be_safe_to_change_visibility
    return unless visibility_changed? && (visibility.in? [VISIBILITY_DRAFT, VISIBILITY_ARCHIVED])
    return if safe_to_change_visibility

    errors[:visibility] << 'cannot be modified unsafely'
  end

  validate :same_course_for_target_and_evaluation_criteria

  def same_course_for_target_and_evaluation_criteria
    return if evaluation_criteria.blank?

    evaluation_criteria.each do |ec|
      next if ec.course_id == course.id

      errors[:base] << 'Target and evaluation criterion must belong to same course'
    end
  end

  normalize_attribute :slideshow_embed, :video_embed, :youtube_video_id, :link_to_complete, :completion_instructions

  def display_name
    if target_group.present?
      "#{course.short_name}##{level.number}: #{title}"
    else
      title
    end
  end

  def founder_role?
    role == Target::ROLE_FOUNDER
  end

  def status(founder)
    @status ||= {}
    @status[founder.id] ||= Targets::StatusService.new(self, founder).status
  end

  def pending?(founder)
    status(founder) == STATUS_PENDING
  end

  def verified?(founder)
    status(founder) == STATUS_COMPLETE
  end

  def session?
    session_at.present?
  end

  def target?
    session_at.blank?
  end

  def founder_event?
    role == ROLE_FOUNDER
  end

  def quiz?
    quiz.present?
  end

  def team_target?
    role == ROLE_TEAM
  end

  # Returns the latest event linked to this target from a founder. If a team target, it responds with the latest event from the team
  def latest_linked_event(founder, exclude = nil)
    owner = founder_role? ? founder : founder.startup

    owner.timeline_events.where.not(id: exclude).where(target: self).order('created_at').last
  end

  def latest_feedback(founder)
    latest_linked_event(founder)&.startup_feedback&.order('created_at')&.last
  end

  def grades_for_skills(founder)
    return unless verified?(founder)
    return if latest_linked_event(founder).timeline_event_grades.blank?

    latest_linked_event(founder).timeline_event_grades.each_with_object({}) do |te_grade, grades|
      grades[te_grade.evaluation_criterion_id] = te_grade.grade
    end
  end

  def latest_content_version_date
    return if content_versions.empty?

    content_versions.maximum(:version_on)
  end

  def current_content_blocks
    return if content_versions.empty?

    ContentBlock.where(id: content_versions.where(version_on: latest_content_version_date).select(:content_block_id))
  end

  def latest_content_versions
    return if content_versions.empty?

    content_versions.where(version_on: latest_content_version_date)
  end
end

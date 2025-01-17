class UpdateSchoolStringMutator < ApplicationQuery
  include AuthorizeSchoolAdmin

  attr_accessor :key
  attr_accessor :value

  validates :key, inclusion: { in: SchoolString::VALID_KEYS, message: 'InvalidKey' }
  validates :value, length: { maximum: 10_000, message: 'InvalidLengthValue' }, allow_blank: true, if: :agreement?
  validates :value, length: { maximum: 1000, message: 'InvalidLengthValue' }, allow_blank: true, if: :address?
  validates :value, email: { message: 'InvalidValue' }, allow_blank: true, if: :email_address?

  def update_school_string
    SchoolString.transaction do
      if value.present?
        school_string = SchoolString.where(school: current_school, key: key).first_or_initialize
        school_string.value = value.strip
        school_string.save!
      else
        SchoolString.where(school: current_school, key: key).destroy_all
      end
    end
  end

  private

  def agreement?
    key.in?([SchoolString::PrivacyPolicy.key, SchoolString::TermsOfUse.key])
  end

  def address?
    key == SchoolString::Address.key
  end

  def email_address?
    key == SchoolString::EmailAddress.key
  end
end

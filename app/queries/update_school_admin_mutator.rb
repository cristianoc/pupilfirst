class UpdateSchoolAdminMutator < ApplicationQuery
  include AuthorizeSchoolAdmin

  attr_accessor :id
  attr_accessor :name

  validates :name, presence: true, length: { maximum: 128 }
  validate :record_must_exists

  def save
    school_admin.user.update!(name: name)
  end

  private

  def record_must_exists
    return if school_admin.present?

    errors[:base] << 'IncorrectSchoolAdminId'
  end

  def school_admin
    @school_admin ||= current_school.school_admins.where(id: id).first
  end
end

class TargetPolicy < ApplicationPolicy
  def show?
    CoursePolicy.new(@pundit_user, record.course).curriculum?
  end

  alias details_v2? show?

  def auto_verify_submission?
    # Has access to school
    return false unless current_school.present? && founder.present? && (course.school == current_school)

    # Founder has access to the course
    return false unless !course.ends_at&.past? && !startup.access_ends_at&.past?

    # Founder can complete the target
    record.level.number <= startup.level.number
  end

  private

  def founder
    @founder ||= current_user.founders.joins(:level).where(levels: { course_id: course }).first
  end

  def startup
    @startup ||= founder.startup
  end

  def course
    @course ||= target.course
  end
end

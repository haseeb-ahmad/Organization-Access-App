class MembershipPolicy < ApplicationPolicy
  def destroy?
    org_membership = user.memberships.find_by(organization: record.organization)
    org_membership&.admin? || org_membership&.moderator?
  end
end
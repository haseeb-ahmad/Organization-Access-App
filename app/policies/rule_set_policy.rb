# app/policies/rule_set_policy.rb
class RuleSetPolicy < ApplicationPolicy
  def index?
    user_member_of_org?
  end

  def show?
    user_member_of_org?
  end

  def create?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

  private

  def user_member_of_org?
    user.member_of?(record.organization)
  end

  def admin?
    user.admin_of?(record.organization)
  end
end

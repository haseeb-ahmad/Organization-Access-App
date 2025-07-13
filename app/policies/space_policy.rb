# app/policies/space_policy.rb
class SpacePolicy < ApplicationPolicy
  def show?
    user_in_org? && (user.joined_spaces.include?(record) || admin?)
  end

  def create?
    admin?
  end

  def new?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def edit?
    update?
  end

  def join?
    user_in_org?
  end

  def leave?
    user_in_org?
  end

  def view_posts?
    user_in_org?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def user_in_org?
    user.member_of?(record.organization)
  end

  def admin?
    user.admin_of?(record.organization)
  end
end

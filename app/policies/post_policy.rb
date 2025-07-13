class PostPolicy < ApplicationPolicy
  # Scope to return only posts that user is allowed to view
  class Scope < Scope
    def resolve
      return scope.none if scope.size.zero?

      membership = organization.memberships.find_by(user: user)

      return scope.none unless membership

      if membership.admin? || membership.moderator?
        scope.all
      else
        scope.select do |post|
          post.author == user || RuleEvaluator.new(post.rule_sets, user).passes?
        end
      end
    end

    private
      def organization
        scope.first&.organization
      end
  end

  def show?
    user_belongs_to_same_organization?
  end

  def create?
    user_belongs_to_same_organization?
  end

  def update?
    user_is_author? || user_is_admin_or_moderator?
  end

  def destroy?
    user_is_author? || user_is_admin_or_moderator?
  end

  def view_rule_sets?
    user_is_admin_or_moderator?
  end

  private

  def user_is_author?
    record.author == user
  end

  def user_is_admin_or_moderator?
    user.admin_or_moderator?(record.organization)
  end

  def user_belongs_to_same_organization?
    record.organization.users.include?(user)
  end

  def passes_rule_sets?
    RuleEvaluator.new(record.rule_sets, user).passes?
  end
end

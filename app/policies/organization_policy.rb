class OrganizationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
     user.organizations
    end
  end
  
  def index?
    admin_or_moderator?
  end

  def show?
    user.member_of?(record)
  end

  def update?
    admin_or_moderator?
  end

  def destroy?
    false
  end

  def create?
    false
  end

  def manage_members?
    admin?
  end
  
  def view_spaces?
    user.member_of?(record)
  end
  
  def manage_rules?
    admin_or_moderator?
  end
  
  def analytics?
    admin?
  end

  def switch?
    user.member_of?(record)
  end
  
  private
  
  def admin?
    user.role_in(record) == "admin"
  end
  
  def admin_or_moderator?
      user.admin_or_moderator?(record)
  end
end

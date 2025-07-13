class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum role: { member: 0, moderator: 1, admin: 2 }

  validates :user_id, uniqueness: { scope: :organization_id }


  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id organization_id role created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user organization]
  end
end

class Organization < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
  has_many :spaces
  has_many :rule_sets, dependent: :destroy


  def self.ransackable_attributes(auth_object = nil)
    %w[id name description created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[memberships users spaces]
  end
end

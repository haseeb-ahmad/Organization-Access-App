class Space < ApplicationRecord
  belongs_to :organization
  has_many :posts, dependent: :destroy
  has_many :space_memberships, dependent: :destroy
  has_many :members, through: :space_memberships, source: :user
  has_many :rule_assignments, as: :ruleable, dependent: :destroy
  has_many :rule_sets, through: :rule_assignments

  def self.ransackable_attributes(auth_object = nil)
    %w[id name description organization_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[organization posts rule_sets]
  end

  def visible_to?(user)
    rule = rule_sets
    rule.nil? || rule.matches_conditions_for?(user)
  end
end

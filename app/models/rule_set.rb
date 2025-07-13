class RuleSet < ApplicationRecord
  RULE_TYPES = %w[post space].freeze

  belongs_to :organization
  has_many :rules, dependent: :destroy
  has_many :rule_assignments, dependent: :destroy

  accepts_nested_attributes_for :rules, allow_destroy: true

  validates :name, presence: true
  validates :rule_type, inclusion: { in: RULE_TYPES }


  def self.rule_type_options
    RULE_TYPES.map { |type| [type, type] }
  end

  def applies_to?(user)
    RuleEvaluator.new(self, user).passes?
  end
end

class Rule < ApplicationRecord
  belongs_to :rule_set

  validates :field, :operator, :value, presence: true
end

class RuleAssignment < ApplicationRecord
  belongs_to :rule_set
  belongs_to :ruleable, polymorphic: true
end

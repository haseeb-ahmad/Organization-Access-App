class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :space
  has_one :organization, through: :space
  has_many :rule_assignments, as: :ruleable, dependent: :destroy
  has_many :rule_sets, through: :rule_assignments
end

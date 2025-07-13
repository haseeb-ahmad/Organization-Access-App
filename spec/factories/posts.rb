FactoryBot.define do
  factory :post do
    content { "MyText" }
    author { nil }
    space { nil }
  end
end

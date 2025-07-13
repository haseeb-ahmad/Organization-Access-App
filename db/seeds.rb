require 'faker'

puts "🌱 Seeding database..."

User.destroy_all
Organization.destroy_all
Membership.destroy_all
Space.destroy_all
Post.destroy_all
Rule.destroy_all
RuleSet.destroy_all
RuleAssignment.destroy_all
AdminUser.destroy_all

# === AdminUser ===
AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password")

# === USERS ===
users = []
10.times do
  user = User.invite!(email: Faker::Internet.unique.email) do |u|
    u.skip_invitation = true
  end

  user.invitation_token = nil
  user.invitation_accepted_at = Time.current
  user.password = "password"
  user.password_confirmation = "password"
  user.dob = rand(10..40).years.ago
  user.custom_attributes = {
    is_verified: [true, false].sample,
    language: %w[en es fr].sample,
    location: %w[California Texas Florida Ontario Quebec].sample
  }
  user.save!
  users << user
end
puts "✅ Created #{users.size} Users (invited and accepted)"

# === ORGANIZATIONS ===
orgs = []
5.times do
  orgs << Organization.create!(
    name: "#{Faker::Company.name} Organization",
    description: Faker::Company.catch_phrase
  )
end
puts "✅ Created #{orgs.size} Organizations"

# === MEMBERSHIPS ===
roles = %i[admin moderator member]

users.each do |user|
  orgs.sample(2).each do |org|
    Membership.create!(
      user: user,
      organization: org,
      role: roles.sample
    )
  end
end
puts "✅ Assigned Users to Organizations with Different Roles"

# === SPACES + RULE SETS ===
space_counter = 0
ruleset_counter = 0

orgs.each do |org|
  3.times do
    space = Space.create!(
      organization: org,
      name: "#{Faker::Hobby.activity} Space",
      description: Faker::Lorem.sentence
    )

    # Create reusable rule set
    ruleset = RuleSet.create!(
      name: "Space Access Rule #{space_counter + 1}",
      rule_type: RuleSet::RULE_TYPES[1], # 'space'
      organization: org
    )

    # Add rules to rule set
    Rule.create!([
      { rule_set: ruleset, field: "age", operator: ">=", value: rand(12..18).to_s },
      { rule_set: ruleset, field: "custom_attributes.location", operator: "in", value: "California,Texas" },
      { rule_set: ruleset, field: "custom_attributes.is_verified", operator: "==", value: "true" }
    ])

    # Assign the rule set to this space
    RuleAssignment.create!(
      rule_set: ruleset,
      ruleable: space
    )

    space_counter += 1
    ruleset_counter += 1
  end
end
puts "✅ Created #{space_counter} Spaces with RuleSets and Rules"

# === POSTS + RULE SETS ===
post_counter = 0

Space.all.each do |space|
  2.times do
    author = space.organization.users.sample
    next unless author

    post = Post.create!(
      space: space,
      author: author,
      content: Faker::Lorem.paragraph
    )

    # 50% chance of attaching a rule set to post
    if [true, false].sample
      ruleset = RuleSet.create!(
        name: "Post Rule #{post_counter + 1}",
        rule_type: RuleSet::RULE_TYPES[0], # 'post'
        organization: space.organization
      )

      Rule.create!([
        { rule_set: ruleset, field: "custom_attributes.language", operator: "==", value: %w[en es fr].sample },
        { rule_set: ruleset, field: "custom_attributes.is_verified", operator: "==", value: "true" }
      ])

      RuleAssignment.create!(
        rule_set: ruleset,
        ruleable: post
      )

      ruleset_counter += 1
    end

    post_counter += 1
  end
end

puts "✅ Created #{post_counter} Posts with optional RuleSets"
puts "🎯 Total RuleSets created: #{ruleset_counter}"
puts "🎉 Done seeding!"


user = User.invite!(email: "dualrole@example.com") do |u|
  u.skip_invitation = true
end

user.invitation_token = nil
user.invitation_accepted_at = Time.current
user.password = "password"
user.password_confirmation = "password"
user.dob = rand(10..40).years.ago
user.custom_attributes = {
  is_verified: [true, false].sample,
  language: %w[en es fr].sample,
  location: %w[California Texas Florida Ontario Quebec].sample
}

user.save!

Membership.create!(user: user, organization: orgs[0], role: :admin)
Membership.create!(user: user, organization: orgs[1], role: :member)


puts "Use Following Credentials for Demo Purpose"
puts "Email: dualrole@example.com"
puts "Password: password"
# app/services/rule_evaluator.rb
class RuleEvaluator
  def initialize(rule_sets, user)
    @rule_sets = rule_sets
    @user = user
  end

  def passes?
    @rule_sets.all? { |rule_set| evaluate(rule_set) }
  end

  private

  def evaluate(rule_set)
    rules = rule_set.rules
    return false if rules.empty?

    rules.any? do |rule|
      user_value = extract_value(rule.field)
      return false if user_value.nil? # Fail fast if user value is missing

      compare(user_value, rule.operator, rule.value)
    end
  end

  def extract_value(field)
    return @user.age if field == 'age'

    parts = field.to_s.split('.')
    parts.reduce(@user) do |obj, attr|
      return nil unless obj.respond_to?(attr)
      obj.send(attr)
    end
  end

  def compare(left, op, right)
    right = coerce_type(right, left)

    case op
    when '=='
      left == right
    when '!='
      left != right
    when '>='
      left >= right
    when '<='
      left <= right
    when '>'
      left > right
    when '<'
      left < right
    when 'in'
      Array(right).include?(left)
    else
      false
    end
  end

  def coerce_type(value, reference)
    return value if reference.nil?

    case reference
    when Integer
      value.to_i
    when Float
      value.to_f
    when TrueClass, FalseClass
      ActiveModel::Type::Boolean.new.cast(value)
    when Date, Time, DateTime
      Time.zone.parse(value.to_s) rescue value
    else
      value
    end
  end
end

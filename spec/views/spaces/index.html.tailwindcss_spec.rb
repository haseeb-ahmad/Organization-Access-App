require 'rails_helper'

RSpec.describe "spaces/index", type: :view do
  before(:each) do
    assign(:spaces, [
      Space.create!(
        organization: nil,
        name: "Name",
        description: "MyText"
      ),
      Space.create!(
        organization: nil,
        name: "Name",
        description: "MyText"
      )
    ])
  end

  it "renders a list of spaces" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end

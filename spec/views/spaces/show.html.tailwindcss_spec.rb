require 'rails_helper'

RSpec.describe "spaces/show", type: :view do
  before(:each) do
    assign(:space, Space.create!(
      organization: nil,
      name: "Name",
      description: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end

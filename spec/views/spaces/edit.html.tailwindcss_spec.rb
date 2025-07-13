require 'rails_helper'

RSpec.describe "spaces/edit", type: :view do
  let(:space) {
    Space.create!(
      organization: nil,
      name: "MyString",
      description: "MyText"
    )
  }

  before(:each) do
    assign(:space, space)
  end

  it "renders the edit space form" do
    render

    assert_select "form[action=?][method=?]", space_path(space), "post" do

      assert_select "input[name=?]", "space[organization_id]"

      assert_select "input[name=?]", "space[name]"

      assert_select "textarea[name=?]", "space[description]"
    end
  end
end

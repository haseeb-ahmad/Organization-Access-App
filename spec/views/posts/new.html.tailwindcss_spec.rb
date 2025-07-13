require 'rails_helper'

RSpec.describe "posts/new", type: :view do
  before(:each) do
    assign(:post, Post.new(
      space: nil,
      author: nil,
      content: "MyText"
    ))
  end

  it "renders new post form" do
    render

    assert_select "form[action=?][method=?]", posts_path, "post" do

      assert_select "input[name=?]", "post[space_id]"

      assert_select "input[name=?]", "post[author_id]"

      assert_select "textarea[name=?]", "post[content]"
    end
  end
end

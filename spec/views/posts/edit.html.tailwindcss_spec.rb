require 'rails_helper'

RSpec.describe "posts/edit", type: :view do
  let(:post) {
    Post.create!(
      space: nil,
      author: nil,
      content: "MyText"
    )
  }

  before(:each) do
    assign(:post, post)
  end

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", post_path(post), "post" do

      assert_select "input[name=?]", "post[space_id]"

      assert_select "input[name=?]", "post[author_id]"

      assert_select "textarea[name=?]", "post[content]"
    end
  end
end

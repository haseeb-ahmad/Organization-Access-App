require 'rails_helper'

RSpec.describe "posts/index", type: :view do
  before(:each) do
    assign(:posts, [
      Post.create!(
        space: nil,
        author: nil,
        content: "MyText"
      ),
      Post.create!(
        space: nil,
        author: nil,
        content: "MyText"
      )
    ])
  end

  it "renders a list of posts" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end

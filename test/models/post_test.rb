require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "stores tags through acts as taggable on" do
    user = create_user(email_address: "post-model@example.com")

    post = Post.create!(
      title: "Rail hop",
      description: "Session clip",
      user: user,
      tag_list: "bmx, street, rail"
    )

    assert_equal [ "bmx", "rail", "street" ], post.tag_list.sort
  end
end

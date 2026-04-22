require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user(email_address: "post-owner@example.com")
    @other_user = create_user(email_address: "post-other@example.com")
    @post = create_post(user: @user)
    @other_post = create_post(user: @other_user)
  end

  test "should get index" do
    sign_in_as(@user)
    get posts_url
    assert_response :success
    assert_select "h2", text: /MyString/, count: 1
    assert_select ".badge", text: /Your post/, count: 0
  end

  test "guest should get index" do
    get posts_url

    assert_response :success
    assert_select "h2", text: /MyString/, count: 2
    assert_select ".badge", text: /Your post/, count: 0
  end

  test "should get new" do
    sign_in_as(@user)
    get new_post_url
    assert_response :success
  end

  test "guest should be redirected from new" do
    get new_post_url

    assert_redirected_to new_session_url
  end

  test "should create post" do
    sign_in_as(@user)

    assert_difference("Post.count") do
      post posts_url, params: {
        post: {
          title: @post.title,
          description: @post.description,
          tag_list: "bmx, street",
          images: [ fixture_file_upload(Rails.root.join("public/icon.png"), "image/png") ]
        }
      }
    end

    assert Post.last.images.attached?
    assert_equal [ "bmx", "street" ], Post.last.reload.tag_list.sort
    assert_redirected_to post_url(Post.last)
  end

  test "should show post" do
    sign_in_as(@user)
    get post_url(@post)
    assert_response :success
  end

  test "guest should show post" do
    get post_url(@post)

    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@user)
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    sign_in_as(@user)

    patch post_url(@post), params: {
      post: {
        title: @post.title,
        description: @post.description,
        tag_list: "toy, setup",
        images: [ fixture_file_upload(Rails.root.join("public/icon.png"), "image/png") ]
      }
    }

    assert @post.reload.images.attached?
    assert_equal [ "setup", "toy" ], @post.reload.tag_list.sort
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    sign_in_as(@user)

    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end

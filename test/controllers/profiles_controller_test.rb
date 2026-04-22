require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user(email_address: "profile-owner@example.com")
    @other_user = create_user(email_address: "profile-other@example.com")
    @user_without_profile = create_user(email_address: "profile-new@example.com")
    @profile = create_profile(user: @user, username: "rider-one", bio: "MyText")
    create_profile(user: @other_user, username: "toy-two", title: "Toy Photographer", bio: "MyText")
  end

  test "should get index" do
    sign_in_as(@user)
    get profiles_url
    assert_response :success
  end

  test "guest should get index" do
    get profiles_url

    assert_response :success
  end

  test "should get new" do
    sign_in_as(@user_without_profile)
    get new_profile_url
    assert_response :success
  end

  test "guest should be redirected from new" do
    get new_profile_url

    assert_redirected_to new_session_url
  end

  test "should create profile" do
    sign_in_as(@user_without_profile)

    assert_difference("Profile.count") do
      post profiles_url, params: { profile: { bio: @profile.bio, title: @profile.title, username: "new-profile" } }
    end

    assert_redirected_to profile_url(Profile.last)
  end

  test "should show profile" do
    sign_in_as(@user)
    get profile_url(@profile)
    assert_response :success
  end

  test "guest should show profile" do
    get profile_url(@profile)

    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@user)
    get edit_profile_url(@profile)
    assert_response :success
  end

  test "should update profile" do
    sign_in_as(@user)

    patch profile_url(@profile), params: { profile: { bio: @profile.bio, title: "Updated title", username: @profile.username } }
    assert_redirected_to profile_url(@profile)
  end

  test "should destroy profile" do
    sign_in_as(@user)

    assert_difference("Profile.count", -1) do
      delete profile_url(@profile)
    end

    assert_redirected_to profiles_url
  end
end

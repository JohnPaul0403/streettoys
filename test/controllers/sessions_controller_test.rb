require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = create_user(email_address: "session-user@example.com") }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
    assert_no_match(/expires=/i, set_cookie_header)
  end

  test "create with remember me" do
    post session_path, params: { email_address: @user.email_address, password: "password", remember_me: "1" }

    assert_redirected_to root_path
    assert cookies[:session_id]
    assert_match(/expires=/i, set_cookie_header)
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(@user)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end

  test "omniauth signs in existing google user" do
    create_user(email_address: "google@example.com", google_uid: "google-123")
    with_mocked_google_oauth(
      provider: "google_oauth2",
      uid: "google-123",
      info: { email: "google@example.com" }
    ) do
      get "/auth/google_oauth2/callback"
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "omniauth creates a user when needed" do
    with_mocked_google_oauth(
      provider: "google_oauth2",
      uid: "new-google-uid",
      info: { email: "brand-new@example.com" }
    ) do
      assert_difference("User.count") do
        get "/auth/google_oauth2/callback"
      end
    end

    assert_equal "new-google-uid", User.order(:created_at).last.google_uid
    assert_redirected_to root_path
  end

  private
    def set_cookie_header
      Array(response.headers["Set-Cookie"]).join("\n")
    end

    def with_mocked_google_oauth(auth_hash)
      original_test_mode = OmniAuth.config.test_mode
      original_mock_auth = OmniAuth.config.mock_auth[:google_oauth2]

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(auth_hash)

      yield
    ensure
      OmniAuth.config.test_mode = original_test_mode
      OmniAuth.config.mock_auth[:google_oauth2] = original_mock_auth
    end
end

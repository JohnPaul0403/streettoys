require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_user_path
    assert_response :success
  end

  test "new shows google signup when oauth is configured" do
    with_google_oauth_env do
      get new_user_path
    end

    assert_response :success
    assert_select "form[action='/auth/google_oauth2'][data-turbo='false']"
    assert_match "Sign up with Google", response.body
  end

  test "new hides google signup when oauth is not configured" do
    without_google_oauth_env do
      get new_user_path
    end

    assert_response :success
    assert_select "form[action='/auth/google_oauth2']", false
  end

  test "create with valid params" do
    assert_difference("User.count") do
      post users_path, params: {
        user: {
          email_address: "new-user@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid params re-renders form" do
    assert_no_difference("User.count") do
      post users_path, params: {
        user: {
          email_address: "",
          password: "short",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  private
    def with_google_oauth_env
      original_client_id = ENV["GOOGLE_CLIENT_ID"]
      original_client_secret = ENV["GOOGLE_CLIENT_SECRET"]

      ENV["GOOGLE_CLIENT_ID"] = "test-client-id"
      ENV["GOOGLE_CLIENT_SECRET"] = "test-client-secret"

      yield
    ensure
      ENV["GOOGLE_CLIENT_ID"] = original_client_id
      ENV["GOOGLE_CLIENT_SECRET"] = original_client_secret
    end

    def without_google_oauth_env
      original_client_id = ENV["GOOGLE_CLIENT_ID"]
      original_client_secret = ENV["GOOGLE_CLIENT_SECRET"]

      ENV.delete("GOOGLE_CLIENT_ID")
      ENV.delete("GOOGLE_CLIENT_SECRET")

      yield
    ensure
      ENV["GOOGLE_CLIENT_ID"] = original_client_id
      ENV["GOOGLE_CLIENT_SECRET"] = original_client_secret
    end
end

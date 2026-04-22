ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
    def create_user(email_address: nil, password: "password", google_uid: nil)
      User.create!(
        email_address: email_address || "user-#{SecureRandom.hex(4)}@example.com",
        password:,
        password_confirmation: password,
        google_uid:
      )
    end

    def create_profile(user:, username: nil, title: "BMX Street Rider", bio: "Profile bio")
      Profile.create!(
        user:,
        username: username || "rider-#{SecureRandom.hex(3)}",
        title:,
        bio:
      )
    end

    def create_post(user:, title: "MyString", description: "MyText")
      Post.create!(
        user:,
        title:,
        description:
      )
    end
  end
end

module ProfilesHelper
  def profile_cache_key(profile, viewer = Current.user)
    [
      "profile-card",
      profile.cache_key_with_version,
      viewer == profile.user
    ]
  end

  def profile_show_cache_key(profile)
    [
      "profile-show",
      profile.cache_key_with_version,
      profile.user.posts.maximum(:updated_at),
      profile.user.posts.count
    ]
  end
end

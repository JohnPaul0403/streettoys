module PostsHelper
  def post_image_tag(image, **options)
    image_tag image, **options
  end

  def post_excerpt(post, length: 180)
    return unless post.description.present?

    truncate(post.description.to_plain_text.squish, length:)
  end

  def post_cache_key(post, viewer = Current.user)
    [
      "post-card",
      post.cache_key_with_version,
      post.user.profile&.cache_key_with_version,
      post.images.attachments.map(&:id),
      viewer == post.user
    ]
  end

  def post_gallery_cache_key(post)
    [
      "post-gallery",
      post.cache_key_with_version,
      post.images.attachments.map(&:id)
    ]
  end

  def post_sidebar_cache_key(post, viewer = Current.user)
    [
      "post-sidebar",
      post.cache_key_with_version,
      post.user.profile&.cache_key_with_version,
      viewer == post.user
    ]
  end
end

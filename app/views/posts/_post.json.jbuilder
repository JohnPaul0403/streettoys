json.extract! post, :id, :title, :user_id, :created_at, :updated_at
json.description post.description.to_plain_text
json.tags post.tag_list
json.url post_url(post, format: :json)

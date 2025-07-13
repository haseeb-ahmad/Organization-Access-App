json.extract! post, :id, :space_id, :author_id, :author_type, :content, :created_at, :updated_at
json.url post_url(post, format: :json)

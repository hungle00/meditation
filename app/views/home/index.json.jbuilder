json.thread_posts @thread_posts do |post|
  json.extract! post, :id, :title, :content, :user_id, :created_at, :updated_at, :comments_count

  json.user do
    json.id post.user.id
    json.name post.user.name
  end
end

json.current_page @thread_posts.current_page
json.total_pages @thread_posts.total_pages
json.total_count @thread_posts.total_count

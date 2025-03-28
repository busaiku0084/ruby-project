require "sinatra"
require "json"
require "securerandom"

set :bind, "0.0.0.0"
set :port, 4567
set :public_folder, File.dirname(__FILE__) + "/public"

POSTS_FILE = "./posts.json"

helpers do
  def load_posts
    File.exist?(POSTS_FILE) ? JSON.parse(File.read(POSTS_FILE)) : []
  end

  def save_posts(posts)
    File.write(POSTS_FILE, JSON.pretty_generate(posts))
  end
end

# 一覧
get "/" do
  @posts = load_posts.sort_by { |p| p["created_at"] }.reverse
  erb :index
end

# 新規投稿フォーム
get "/new" do
  erb :new
end

# 投稿作成
post "/create" do
  posts = load_posts
  new_post = {
    "id" => SecureRandom.uuid,
    "title" => params[:title],
    "body" => params[:body],
    "created_at" => Time.now.strftime("%Y-%m-%d %H:%M")
  }
  posts << new_post
  save_posts(posts)
  redirect "/"
end

# 編集フォーム
get "/edit/:id" do
  @posts = load_posts
  @post = @posts.find { |p| p["id"] == params[:id] }
  halt 404, "Post not found" unless @post
  erb :edit
end

# 更新処理
post "/update/:id" do
  posts = load_posts
  post = posts.find { |p| p["id"] == params[:id] }
  halt 404, "Post not found" unless post

  post["title"] = params[:title]
  post["body"] = params[:body]
  save_posts(posts)
  redirect "/"
end

# 削除処理
post "/delete/:id" do
  posts = load_posts.reject { |p| p["id"] == params[:id] }
  save_posts(posts)
  redirect "/"
end

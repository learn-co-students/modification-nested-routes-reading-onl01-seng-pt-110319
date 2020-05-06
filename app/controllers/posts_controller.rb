class PostsController < ApplicationController

  def index
    if params[:author_id]
      @posts = Author.find(params[:author_id]).posts
    else
      @posts = Post.all
    end
  end

  def show
    if params[:author_id]
      @post = Author.find(params[:author_id]).posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  def new
    if params[:author_id] && !Author.exists?(params[:author_id]) #checking if author_id in params and if he exists 
      redirect_to authors_path, alert: "Author not found." #if he doesnt redircect to authors page and alert 
    else
      @post = Post.new(author_id: params[:author_id]) #otherwise good to make a new post
    end 
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def edit
    if params[:author_id] #looking for existence of author, would come from nested route 
      author = Author.find_by(id: params[:id]) #if its there, look for valid author 
      if author.nil? 
        redirect_to authors_path, alert: "Author not found." #if not there redirect to authors path, w/ flash[:alert]
      else 
        @post = author.posts.find_by(id: params[:id]) #if we find valid author, we want to look through author's 
        #collection to find this post 
        #because it may be a valid post id, but it may not belong to this author, and that makes it invalid 
        redirect_to author_posts_path(author), alert: "Post not found." if @post.nil? 
      end 
    else 
      @post = Post.find_by(params[:id])
    end 
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :author_id)
  end
end

class HomeController < ApplicationController
  def index
    @posts = Post.all.future.limit(10)
  end
end

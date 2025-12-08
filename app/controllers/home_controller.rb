class HomeController < ApplicationController
  def index
    @posts = Post.all.past.limit(25)
  end
end
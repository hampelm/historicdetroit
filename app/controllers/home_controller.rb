class HomeController < ApplicationController
  def index
    @posts = Post.all.past.limit(25)

    # Get buildings and galleries added recently
    @new = Gallery.order('created_at DESC').limit(4).to_a
    Building.order('created_at DESC').limit(4).each do |building|
      @new << building
    end
    @new = @new.sort_by(&:created_at).reverse.take(4)
    
  end
end
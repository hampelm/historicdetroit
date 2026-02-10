class HomeController < ApplicationController
  def index
    @posts = Post.all.past.limit(25)
    
    # Fetch recent published galleries
    galleries = Gallery.unscoped.where(published: true)
                       .order(created_at: :desc)
                       .limit(3)
    
    # Fetch recent buildings
    buildings = Building.unscoped.order(created_at: :desc)
                       .limit(3)
    
    # Combine and sort by created_at, take top 3
    @recent_items = (galleries + buildings)
                    .sort_by { |item| item.created_at }
                    .reverse
                    .take(3)
  end
end

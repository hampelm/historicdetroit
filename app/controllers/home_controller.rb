class HomeController < ApplicationController
  def index
    @posts = Post.all.past.limit(25)
    
    # Fetch recent published galleries
    galleries = Gallery.unscoped.where(published: true)
                       .order(created_at: :desc)
                       .limit(3)
    
    # Fetch recent buildings (consider both created_at and last_update)
    buildings = Building.unscoped
                       .order(Arel.sql('GREATEST(COALESCE(last_update, created_at), created_at) DESC'))
                       .limit(3)
    
    # Combine and sort by effective date (most recent of created_at or last_update), take top 3
    @recent_items = (galleries + buildings)
                    .sort_by { |item| effective_date(item) }
                    .reverse
                    .take(3)
  end

  private

  # Returns the most recent date between created_at and last_update (for buildings)
  def effective_date(item)
    if item.is_a?(Building) && item.last_update.present?
      [item.created_at, item.last_update].max
    else
      item.created_at
    end
  end

  helper_method :effective_date

  # Returns the label ("added" or "updated") based on which date is more recent
  def recent_label(item)
    if item.is_a?(Building) && item.last_update.present? && item.last_update > item.created_at
      "updated"
    else
      "added"
    end
  end

  helper_method :recent_label
end

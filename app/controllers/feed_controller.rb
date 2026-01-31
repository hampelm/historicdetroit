class FeedController < ApplicationController
  def index
    # Fetch recent posts (excluding future-dated ones)
    posts = Post.past.limit(30).map do |post|
      {
        type: 'post',
        title: post.title,
        description: post.body_formatted,
        url: post_url(post),
        timestamp: post.date,
        photo: post.photo.present? ? post.photo.url : nil,
        item: post
      }
    end

    # Fetch recent published galleries
    galleries = Gallery.where(published: true)
                       .order(created_at: :desc)
                       .limit(30)
                       .map do |gallery|
      {
        type: 'gallery',
        title: gallery.title,
        description: gallery.description,
        url: gallery_url(gallery),
        timestamp: gallery.created_at,
        photo: gallery.photo? ? gallery.photo.url : nil,
        item: gallery
      }
    end

    # Fetch recent buildings
    buildings = Building.order(created_at: :desc)
                       .limit(30)
                       .map do |building|
      {
        type: 'building',
        title: building.name,
        description: building.description_formatted,
        url: building_url(building),
        timestamp: building.created_at,
        photo: building.photo.present? ? building.photo.url : nil,
        item: building
      }
    end

    # Combine all items and sort by timestamp
    @items = (posts + galleries + buildings)
             .sort_by { |item| item[:timestamp] }
             .reverse
             .take(30)

    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end

class PagesController < ApplicationController
  before_action :get_pages

  def index
    @page = Page.friendly.find('about')
  end

  def show
    @page = Page.friendly.find(params[:id])
    render :template => 'pages/index'
  end

  private
  def get_pages
    @pages = Page.all
  end
end

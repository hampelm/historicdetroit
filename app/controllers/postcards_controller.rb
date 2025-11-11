class PostcardsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def subject
    @subject = Subject.friendly.find(params[:subject])
    @postcards = @subject.postcards
  end

  def building
    @building = Building.friendly.find(params[:slug])
    @postcards = @building.postcards
  end

  def show
    @postcard = Postcard.includes(buildings: :postcards).find(params[:id])
    @subjects = @postcard.subjects.includes(:postcards)
  end
end

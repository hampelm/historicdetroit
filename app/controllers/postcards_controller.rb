class PostcardsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def subject
    @subject = Subject.friendly.find(params[:subject])
    @postcards = @subject.postcards
  end

  def show
    @subject = Subject.friendly.find(params[:subject])
    @postcard = Postcard.find(params[:id])
  end
end

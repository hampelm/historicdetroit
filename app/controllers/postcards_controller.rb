class PostcardsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def subject
    @subject = Subject.friendly.find(params[:subject])
    @postcards = @subject.postcards
  end

  def show
    @postcard = Postcard.find(params[:id])
    @subjects = @postcard.subjects
  end
end

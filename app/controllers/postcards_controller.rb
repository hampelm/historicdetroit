class PostcardsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def subject
    @subject = Subject.friendly.find(params[:subject])
    @postcards = Postcard.where(subject: @subject)
  end

  def show
    @subject = Subject.friendly.find(params[:subjec=])
    @postcard = Postcard.find(params[:id])
  end

end

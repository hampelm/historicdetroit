class HomesController < ApplicationController
  def index
    @subject = Subject.friendly.find('homes')
    @buildings = @subject.buildings

    # TODO: This query is very expensive
    @subjects = @buildings.collect(&:subjects).flatten.uniq.without(@subject)
  end

  def subject
    # Get only homes that match this subject
    @subject = Subject.friendly.find(params[:subject])
    @homes_subject = Subject.friendly.find('homes')
    @homes = @subject.buildings #.where(subjects: [@homes_subject])
  end

  # `show` is handled by the BuildingsController
end

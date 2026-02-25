class HomesController < ApplicationController
  def index
    @subject = Subject.friendly.find('homes')
    @buildings = @subject.buildings

    # Single query using subquery to avoid DISTINCT + ORDER BY conflict
    @subjects = Subject.where(
      id: Subject.unscoped
                 .joins(:buildings)
                 .where(buildings: { id: @buildings.select(:id) })
                 .where.not(title: ['Homes', 'Buildings'])
                 .select(:id)
                 .distinct
    )
  end

  def subject
    # Get only homes that match this subject
    @subject = Subject.friendly.find(params[:subject])
    @homes_subject = Subject.friendly.find('homes')
    @homes = @subject.buildings.distinct #.where(subjects: [@homes_subject])
  end

  # `show` is handled by the BuildingsController
end

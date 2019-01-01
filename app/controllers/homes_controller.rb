class HomesController < ApplicationController
  def index
    @subject = Subject.friendly.find('homes')
    @buildings = @subject.buildings
    @subjects = @buildings.collect { |b| b.subjects }.flatten.uniq.without(@subject)
  end
end

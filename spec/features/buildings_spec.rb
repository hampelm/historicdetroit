require 'rails_helper'

RSpec.feature 'Buildings ', type: :feature do
  before(:all) do
    @building1 = FactoryBot.create :building
    @building2 = FactoryBot.create :building
  end

  scenario 'Buildings page lists all buildings' do
    visit '/buildings'
    expect(page).to have_content @building1.name
    expect(page).to have_content @building2.name
  end

  scenario 'Building page has building details' do
    visit "/buildings/#{@building1.slug}"
    expect(page).to have_content @building1.name
    expect(page).to have_content @building1.byline
    expect(page).to have_content @building1.address
    expect(page).to have_content @building1.status
    expect(page).to have_content @building1.style
    expect(page).to have_content @building1.year_opened
    expect(page).to have_content @building1.year_closed
    expect(page).to have_content @building1.year_demolished
    expect(page).to have_content @building1.also_known_as
  end

  scenario 'Old style building urls work' do
    visit "/building/#{@building1.slug}"
    expect(page).to have_content @building1.name
    expect(page).to have_content @building1.byline
  end
end



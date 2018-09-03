require 'rails_helper'

RSpec.feature 'Admin section', type: :feature do
  before(:all) do
    @user = create :user
    @admin = create :user, :admin
  end

  scenario 'anonymous visitors cannot access the admin section' do
    visit '/admin'
    expect(page).to have_content 'You need to sign in or sign up'
  end

  scenario 'regular users cannot log in to the admin section' do
    sign_in @user
    visit '/admin'
    expect(page).to have_content 'Welcome to Historic Detroit'
  end


  scenario 'admin users can log in to the admin section' do
    sign_in @admin
    visit '/admin'
    expect(page).to have_content 'Admin Site'
  end

end

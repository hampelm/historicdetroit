require 'rails_helper'

RSpec.feature 'Admin', type: :feature do
  before(:all) do
    @user = create :user
    @admin = create :user, :admin
  end

  scenario 'Only admin users can log in to the admin section' do
    visit '/admin'
    expect(page).to have_content 'You need to sign in or sign up'

    sign_in users(@user)
    visit '/admin'
    expect(page).to have_content 'You need to sign in or sign up'


    sign_in users(@admin)
    visit '/admin'
    expect(page).to have_content 'You need to sign in or sign up'
  end
end

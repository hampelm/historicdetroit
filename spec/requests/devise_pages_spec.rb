require 'rails_helper'

# Render every Devise page, so a removed Devise helper fails here.
RSpec.describe 'Devise pages', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create :user }

  it 'renders the sign in page' do
    get new_user_session_path
    expect(response).to have_http_status(:ok)
  end

  it 'renders the forgot password page' do
    get new_user_password_path
    expect(response).to have_http_status(:ok)
  end

  it 'renders the reset password page' do
    token = user.send(:set_reset_password_token)
    get edit_user_password_path(reset_password_token: token)
    expect(response).to have_http_status(:ok)
  end

  it 'renders the sign up page' do
    get new_user_registration_path
    expect(response).to have_http_status(:ok)
  end

  it 'renders the edit account page' do
    sign_in user
    get edit_user_registration_path
    expect(response).to have_http_status(:ok)
  end

  it 'shows error messages when sign up fails' do
    post user_registration_path, params: { user: { email: '', password: 'x', password_confirmation: 'y' } }
    expect(response.body).to include('error_explanation')
  end
end

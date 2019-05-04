# == Schema Information
#
# Table name: subjects
#
#  id            :integer          not null, primary key
#  title         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#  photo         :string
#  use_as_filter :boolean
#

require 'rails_helper'

RSpec.describe Subject, type: :model do
  let(:subject) { FactoryBot.create :subject }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'has a slug' do
    subject = Subject.new
    subject.title = 'hello world'
    subject.save
    expect(subject.slug).to eq 'hello-world'
  end
end

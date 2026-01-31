require 'rails_helper'

RSpec.describe FeedController, type: :controller do
  render_views
  
  describe 'GET #index' do
    context 'RSS feed generation' do
      before do
        # Create posts with past and future dates
        @past_post1 = create(:post, title: 'Past Post 1', date: 2.days.ago)
        @past_post2 = create(:post, title: 'Past Post 2', date: 5.days.ago)
        @future_post = create(:post, title: 'Future Post', date: 2.days.from_now)

        # Create published and unpublished galleries
        @published_gallery = create(:gallery, title: 'Published Gallery', published: true)
        @unpublished_gallery = create(:gallery, title: 'Unpublished Gallery', published: false)

        # Create buildings
        @building1 = create(:building, name: 'Test Building 1')
        @building2 = create(:building, name: 'Test Building 2')
      end

      it 'responds successfully with RSS format' do
        get :index, format: :rss
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/rss+xml; charset=utf-8')
      end

      it 'includes past posts in the feed' do
        get :index, format: :rss
        expect(response.body).to include('Past Post 1')
        expect(response.body).to include('Past Post 2')
      end

      it 'excludes future posts from the feed' do
        get :index, format: :rss
        expect(response.body).not_to include('Future Post')
      end

      it 'includes published galleries in the feed' do
        get :index, format: :rss
        expect(response.body).to include('Published Gallery')
      end

      it 'excludes unpublished galleries from the feed' do
        get :index, format: :rss
        expect(response.body).not_to include('Unpublished Gallery')
      end

      it 'includes buildings in the feed' do
        get :index, format: :rss
        expect(response.body).to include('Test Building 1')
        expect(response.body).to include('Test Building 2')
      end

      it 'generates valid RSS XML structure' do
        get :index, format: :rss
        xml_doc = Nokogiri::XML(response.body)

        # Check for RSS root element
        expect(xml_doc.at_xpath('//rss')).to be_present
        expect(xml_doc.at_xpath('//rss')['version']).to eq('2.0')

        # Check for channel element
        expect(xml_doc.at_xpath('//channel')).to be_present
        expect(xml_doc.at_xpath('//channel/title').text).to eq('Historic Detroit')
        expect(xml_doc.at_xpath('//channel/description')).to be_present
        expect(xml_doc.at_xpath('//channel/link')).to be_present
      end

      it 'includes required RSS item elements' do
        get :index, format: :rss
        xml_doc = Nokogiri::XML(response.body)

        # Get first item
        item = xml_doc.at_xpath('//item')
        expect(item).to be_present

        # Check required elements
        expect(item.at_xpath('title')).to be_present
        expect(item.at_xpath('description')).to be_present
        expect(item.at_xpath('link')).to be_present
        expect(item.at_xpath('pubDate')).to be_present
        expect(item.at_xpath('guid')).to be_present
      end

      it 'includes category tags for item types' do
        get :index, format: :rss
        xml_doc = Nokogiri::XML(response.body)

        categories = xml_doc.xpath('//item/category').map(&:text)
        expect(categories).to include('Post')
        expect(categories).to include('Gallery')
        expect(categories).to include('Building')
      end

      it 'limits feed to 30 items' do
        # Create more than 30 items
        20.times { create(:post, date: rand(30).days.ago) }
        15.times { create(:gallery, published: true) }
        10.times { create(:building) }

        get :index, format: :rss
        xml_doc = Nokogiri::XML(response.body)

        item_count = xml_doc.xpath('//item').count
        expect(item_count).to eq(30)
      end

      it 'sorts items by timestamp in descending order' do
        # Create items with specific dates
        old_post = create(:post, title: 'Old Post', date: 10.days.ago)
        recent_post = create(:post, title: 'Recent Post', date: 1.day.ago)

        get :index, format: :rss
        xml_doc = Nokogiri::XML(response.body)

        items = xml_doc.xpath('//item/title').map(&:text)
        recent_index = items.index('Recent Post')
        old_index = items.index('Old Post')

        # Recent post should appear before old post
        expect(recent_index).to be < old_index
      end
    end

    context 'routing' do
      it 'routes /feed to feed#index with RSS format' do
        expect(get: '/feed').to route_to(
          controller: 'feed',
          action: 'index',
          format: 'rss'
        )
      end
    end
  end
end

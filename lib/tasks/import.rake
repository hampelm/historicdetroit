require 'open-uri'

image_base = 'http://www.historicdetroit.org/workspace/images/'

namespace :import do
  # Import buildings
  desc 'Import buildings from Historic Detroit'
  task :buildings, [:base_path] => :environment do
    base_path = args[:base_path]

    # First, figure out how many pages we have.
    doc = Nokogiri::XML(open(base_path + '1'))
    total_pages = doc.css('pagination').attribute('total-pages').to_s.to_i

    # Then loop over all of them
    (1..total_pages).each do |page_num|
      doc = Nokogiri::XML(open(base_path + page_num))
      doc.css('data buildings-export entry').each do |b|
        slug = b.css('building-name').attribute('handle').to_s
        exists = Building.exists?(slug: slug)
        puts "Skipping #{slug}" if exists
        next if exists
        puts "Importing #{slug}"

        building = Building.new(
          name: b.css('building-name').text,
          slug: slug,
          also_known_as: b.css('also-known-as').text,
          byline: b.css('byline').text,
          description: b.xpath("//description[@mode='unformatted']").first.text,
          address: b.css('address').text,
          style: b.css('style').text,
          status: b.css('status item').text,
          year_opened: b.css('year-opened').text,
          year_closed: b.css('year-closed').text,
          year_demolished: b.css('year-demolished').text,
        )

        unless b.css('location').empty?
          building.lat = b.css('location').attribute('latitude')
          building.lng = b.css('location').attribute('longitude')
        end

        building.save

        # Get the image(s)
        unless b.css('image').empty?
          filename = b.css('image filename').text.to_s
          image = open(image_base + filename)
          building.photo.attach(io: image, filename: filename)
        end

      end
    end
  end
end

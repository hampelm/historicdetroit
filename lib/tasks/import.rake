require 'open-uri'

image_base = 'http://www.historicdetroit.org/workspace/images/'

namespace :import do
  desc 'Import archtects (run first)'
  task :architects, [:base_path] => :environment do |_, args|
    base_path = args[:base_path]

    # Then loop over all of them
    doc = Nokogiri::XML(open(base_path))
    doc.css('data architects-export entry').each do |b|
      slug = b.css('name').attribute('handle').to_s
      exists = Architect.exists?(slug: slug)
      puts "Skipping #{slug}" if exists
      next if exists
      puts "Importing #{slug}"

      architect = Architect.new(
        name: b.css('name').text,
        slug: slug,
        last_name_first: b.css('last-name-first').text,
        description: b.xpath("description[@mode='unformatted']").first.andand.text || ''
      )

      architect.byline = b.css('byline').text unless b.css('byline').empty?
      architect.birth  = b.css('birth').text  unless b.css('birth').empty?
      architect.death  = b.css('death').text  unless b.css('death').empty?

      ActiveRecord::Base.record_timestamps = false
      architect.created_at = Time.iso8601(b.css('system-date created').attribute('iso').to_s)
      architect.updated_at = Time.iso8601(b.css('system-date modified').attribute('iso').to_s)
      architect.save

      next if b.css('image').empty?

      # Get the image(s)
      ActiveRecord::Base.record_timestamps = true
      filename = b.css('image filename').text.to_s
      image = open(image_base + filename)
      architect.photo.attach(io: image, filename: filename)
    end
  end

  desc 'Import buildings (run second)'
  task :buildings, [:base_path] => :environment do |task, args|
    base_path = args[:base_path]

    # First, figure out how many pages we have.
    doc = Nokogiri::XML(open(base_path + '1'))
    total_pages = doc.css('pagination').attribute('total-pages').to_s.to_i

    # Then loop over all of them
    (1..total_pages).each do |page_num|
      doc = Nokogiri::XML(open(base_path + page_num.to_s))
      doc.css('data buildings-export entry').each do |b|
        slug = b.css('building-name').attribute('handle').to_s
        exists = Building.exists?(slug: slug)
        puts "Skipping #{slug}" if exists
        next if exists
        puts "Importing #{slug}"

        description = b.xpath("description[@mode='unformatted']").first.andand.text || ''

        # Ensure markdown headers have spacing.
        # Eg ###Foo becomes ### Foo
        description.gsub!(/^(#*)(\w)/, '\1 \2')

        building = Building.new(
          name: b.css('building-name').text,
          slug: slug,
          also_known_as: b.css('also-known-as').text,
          byline: b.css('byline').text,
          description: description,
          address: b.css('address').text,
          style: b.css('style').text,
          status: b.css('status item').text,
          year_opened: b.css('year-opened').text,
          year_closed: b.css('year-closed').text,
          year_demolished: b.css('year-demolished').text
        )

        unless b.css('location').empty?
          building.lat = b.css('location').attribute('latitude')
          building.lng = b.css('location').attribute('longitude')
        end

        building.save

        # Get the image(s)
        next if b.css('image').empty?
        filename = b.css('image filename').text.to_s
        image = open(image_base + filename)
        building.photo.attach(io: image, filename: filename)
      end
    end
  end

  desc 'Import galleries'
  task :galleries, [:base_path] => :environment do |_, args|
    base_path = args[:base_path]

    # First, figure out how many pages we have.
    doc = Nokogiri::XML(open(base_path + '1'))
    total_pages = doc.css('pagination').attribute('total-pages').to_s.to_i

    # Then loop over all of them
    (1..total_pages).each do |page_num|
      doc = Nokogiri::XML(open(base_path + page_num.to_s))
      doc.css('data gallery-export entry').each do |b|
        slug = b.css('name').attribute('handle').to_s
        exists = Gallery.exists?(slug: slug)
        puts "Skipping #{slug}" if exists
        next if exists
        puts "Importing #{slug}"

        gallery = Gallery.new(
          title: b.css('name').text,
          slug: slug
        )

        # Attach the building
        unless b.css('building item').empty?
          building_slug = b.css('building item')[0].attribute('handle').to_s
          building = Building.friendly.find(building_slug)
          gallery.building = building
        end

        # Set the timestamps
        ActiveRecord::Base.record_timestamps = false
        gallery.created_at = Time.iso8601(b.css('system-date created').attribute('iso').to_s)
        gallery.updated_at = Time.iso8601(b.css('system-date modified').attribute('iso').to_s)
        gallery.save

        # Attach the photos
        ActiveRecord::Base.record_timestamps = true
        b.css('images image').each do |image|
          filename = image.css('filename').text.to_s
          puts "-- image #{filename}"
          image_file = open(image_base + filename)
          photo = Photo.new(
            caption: image.css('caption').text,
            byline: image.css('byline').text,
            gallery: gallery
          )
          photo.save
          photo.photo.attach(io: image_file, filename: filename)
        end
      end
    end
  end


  desc 'Import subjects'
  task :subjects, [:base_path] => :environment do |task, args|
    base_path = args[:base_path]

    doc = Nokogiri::XML(open(base_path))
    doc.css('data subjects-export entry').each do |b|
      slug = b.css('subject').attribute('handle').to_s
      exists = Subject.exists?(slug: slug)
      puts "Skipping #{slug}" if exists
      next if exists
      puts "Importing #{slug}"

      subject = Subject.new(
        title: b.css('subject').text,
        slug: slug
      )

      # Set the timestamps
      ActiveRecord::Base.record_timestamps = false
      subject.created_at = Time.iso8601(b.css('system-date created').attribute('iso').to_s)
      subject.updated_at = Time.iso8601(b.css('system-date modified').attribute('iso').to_s)
      subject.save

      # Get the image(s)
      ActiveRecord::Base.record_timestamps = true
      next if b.css('image').empty?
      filename = b.css('image filename').text.to_s
      image = open(image_base + '/subjects/' + filename)
      subject.photo.attach(io: image, filename: filename)
    end
  end

  desc 'Import postcards'
  task :postcards, [:base_path] => :environment do |_, args|
    base_path = args[:base_path]

    # First, figure out how many pages we have.
    doc = Nokogiri::XML(open(base_path + '1'))
    total_pages = doc.css('pagination').attribute('total-pages').to_s.to_i

    # Then loop over all of them
    (1..total_pages).each do |page_num|
      doc = Nokogiri::XML(open(base_path + page_num.to_s))
      doc.css('data postcards-export entry').each do |b|

        slug = b.css('title').attribute('handle').to_s
        exists = Postcard.exists?(slug: slug)
        puts "Skipping #{slug}" if exists
        next if exists
        puts "Importing #{slug}"

        postcard = Postcard.new(
          title: b.css('title').text,
          slug: slug
        )

        # TODO -- start up here.
        # need to attach multiple buildings

        # Attach the building
        buildings = b.css('buildings item')
        buildings.each do |building|
          building_slug = building.attribute('handle').to_s
          building = Building.friendly.find(building_slug)
          poscard.building = building
        end

        # Set the timestamps
        ActiveRecord::Base.record_timestamps = false
        postcard.created_at = Time.iso8601(b.css('system-date created').attribute('iso').to_s)
        postcard.updated_at = Time.iso8601(b.css('system-date modified').attribute('iso').to_s)
        postcard.save

        # Attach the photos
        ActiveRecord::Base.record_timestamps = true
        b.css('images image').each do |image|
          filename = image.css('filename').text.to_s
          puts "-- image #{filename}"
          image_file = open(image_base + filename)
          photo = Photo.new(
            caption: image.css('caption').text,
            byline: image.css('byline').text,
            gallery: gallery
          )
          photo.save
          photo.photo.attach(io: image_file, filename: filename)
        end
      end
    end
  end
end

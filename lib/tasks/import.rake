require 'open-uri'

image_base = 'http://www.historicdetroit.org/workspace/images/'

architect_fixes = {
  'e-r-dunlap' => 'er-dunlap',
  'h-h-richardson' => 'hh-richardson',
  'h-j-maxwell-grylls' => 'hj-maxwell-grylls',
  'j-h-gustav-steffens' => 'jh-gustav-steffens',
  'v-j-waier' => 'vj-waier',
  'l-p-rowe' => 'lp-rowe',
  'cyrus-l-w-eidlitz' => 'cyrus-lw-eidlitz',
  'a-h-gould-and-amp-son' => 'ah-gould-and-son',
  'a-h-gould-and-son' => 'ah-gould-and-son',
  'william-e-n-hunter' => 'william-en-hunter'
}

building_fixes = {
  'u-s-mortgage-bond-building' => 'us-mortgage-bond-building'
}

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

      unless b.css('image').empty?
        filename = b.css('image filename').text.to_s
        architect.remote_photo_url = image_base + filename
      end

      architect.save
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
      url = base_path + page_num.to_s
      puts url
      doc = Nokogiri::XML(open(url))
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

        b.css('architect item').each do |architect|
          architect_slug = architect.attribute('handle').to_s
          architect_slug.sub! '-amp', ''
          architect_slug = architect_fixes[architect_slug] || architect_slug
          puts "Trying architect #{architect_slug}"
          arch = Architect.friendly.find(architect_slug)
          building.architects << arch if arch
        end
        building.architects = building.architects.distinct

        # Get the image(s)
        unless b.css('image').empty?
          filename = b.css('image filename').text.to_s
          building.remote_photo_url = image_base + filename
        end

        saved = building.save
        puts building.errors.full_messages unless saved
        exit(1) unless saved
      end
    end
  end

  desc 'Import homes (run third)'
  task :homes, [:base_path] => :environment do |task, args|
    base_path = args[:base_path]

    # Manually add a Homes subject
    subject = Subject.find_or_create_by(
      title: 'Homes',
      slug: 'homes'
    )

    # First, figure out how many pages we have.
    doc = Nokogiri::XML(open(base_path + '1'))
    total_pages = doc.css('pagination').attribute('total-pages').to_s.to_i

    # Then loop over all of them
    (1..total_pages).each do |page_num|
      url = base_path + page_num.to_s
      puts url
      doc = Nokogiri::XML(open(url))
      doc.css('data homes-export entry').each do |b|
        slug = b.css('name').attribute('handle').to_s
        building = Building.find_by(slug: slug) || Building.new
        # puts "Skipping #{slug}" if exists
        # next if exists
        puts "Importing #{slug}"

        description = b.xpath("description[@mode='unformatted']").first.andand.text || ''

        # Ensure markdown headers have spacing.
        # Eg ###Foo becomes ### Foo
        description.gsub!(/^(#*)(\w)/, '\1 \2')

        building.assign_attributes({
          name: b.css('name').text,
          slug: slug,
          byline: b.css('byline').text,
          description: description,
          address: b.css('address').text,
          status: b.css('status item').text,
          year_built: b.css('year-built').text,
          year_demolished: b.css('year-demolished').text
        })

        unless b.css('location').empty?
          building.lat = b.css('location').attribute('latitude')
          building.lng = b.css('location').attribute('longitude')
        end

        b.css('architect item').each do |architect|
          architect_slug = architect.attribute('handle').to_s
          architect_slug.sub! '-amp', ''
          architect_slug = architect_fixes[architect_slug] || architect_slug
          puts "Trying architect #{architect_slug}"
          arch = Architect.friendly.find(architect_slug)
          building.architects << arch if arch
        end
        building.architects = building.architects.distinct

        # Get the image(s)
        unless b.css('image').empty?
          filename = b.css('image filename').text.to_s
          building.remote_photo_url = image_base + 'homes/' + filename
        end

        # Set the subjects
        building.subjects << subject # Mark this as a home
        subjects = b.css('subjects item')
        subjects.each do |subject|
          subject_slug = subject.attribute('handle').to_s
          puts "-- finding subject #{subject_slug}"
          building.subjects << Subject.friendly.find(subject_slug)
        end
        building.subjects = building.subjects.distinct

        saved = building.save
        puts building.errors.full_messages unless saved
        exit(1) unless saved
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

        gallery = Gallery.where(slug: slug).first
        unless gallery.nil?
          puts "Gallery #{slug} exists, checking count"
          num_photos = b.css('images item').count
          next if num_photos <= gallery.photos.count
          puts "Bad import for #{slug}, deleting and starting again"
          gallery.photos.each do |photo|
            puts "Removing photo... #{photo.id}"
            photo.destroy
          end

          puts 'Removing gallery'
          gallery.destroy
          puts 'Removed gallery'
        end

        puts "Importing #{slug}"

        gallery = Gallery.new(
          title: b.css('name').text,
          slug: slug
        )

        # Attach the building
        unless b.css('building item').empty?
          building_slug = b.css('building item')[0].attribute('handle').to_s
          building_slug = building_fixes[building_slug] || building_slug
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

        b.css('images item').each do |image|
          filename = image.css('filename').text.to_s
          puts "-- image #{filename}"
          photo = Photo.new(
            caption: image.css('caption').text,
            byline: image.css('byline').text,
            gallery: gallery,
            remote_photo_url: image_base + filename
          )
          photo.save
          gallery.photos << photo if photo
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
      subject = Subject.find_by(slug: slug) || Subject.new

      subject.assign_attributes({
        title: b.css('subject').text,
        slug: slug
      })

      # Set the timestamps
      ActiveRecord::Base.record_timestamps = false
      subject.created_at = Time.iso8601(b.css('system-date created').attribute('iso').to_s)
      subject.updated_at = Time.iso8601(b.css('system-date modified').attribute('iso').to_s)

      # Get the image(s)
      unless b.css('image').empty?
        filename = b.css('image filename').text.to_s
        subject.remote_photo_url = image_base + 'subjects/' + filename
      end

      subject.save
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
          id: b.attribute('id').to_s.to_i,
          title: b.css('title').text,
          slug: slug
        )

        # TODO -- start up here.
        # need to attach multiple buildings

        # Attach the building
        buildings = b.css('buildings item')
        buildings.each do |building|
          building_slug = building.attribute('handle').to_s
          puts "-- finding building #{building_slug}"
          begin
            building = Building.friendly.find(building_slug)
            postcard.buildings << building if building
          rescue
            puts "#{building_slug} not found!"
          end
        end

        subjects = b.css('subjects item')
        subjects.each do |subject|
          subject_slug = subject.attribute('handle').to_s
          puts "-- finding subject #{subject_slug}"
          postcard.subjects << Subject.friendly.find(subject_slug)
        end

        # Set the timestamps
        ActiveRecord::Base.record_timestamps = false
        postcard.created_at = Time.iso8601(b.css('system-date created').attribute('iso').to_s)
        postcard.updated_at = Time.iso8601(b.css('system-date modified').attribute('iso').to_s)

        b.css('front').each do |image|
          filename = image.css('filename').text.to_s
          puts "-- image #{filename}"
          postcard.remote_front_url = image_base + 'postcards/' + filename
        end

        b.css('back').each do |image|
          filename = image.css('filename').text.to_s
          puts "-- image #{filename}"
          postcard.remote_back_url = image_base + 'postcards/' + filename
        end

        postcard.save
      end
    end
  end

  desc 'Import posts'
  task :posts, [:base_path] => :environment do |task, args|
    base_path = args[:base_path]

    doc = Nokogiri::XML(open(base_path))
    doc.css('data post-export entry').each do |b|
      post = Post.new
      title = b.css('title').text
      post.assign_attributes({
        title: title,
        body: b.xpath("body[@mode='unformatted']").first.andand.text || ''
      })

      puts "Adding #{title}"

      # Find associated buildings
      b.css('buildings item').each do |building|
        building_slug = building.attribute('handle').to_s
        building_slug.sub! '-amp', ''
        puts "-- Trying to find associated building #{building_slug}"
        bldg = Building.friendly.find(building_slug)
        post.buildings << bldg if bldg
      end
      post.buildings = post.buildings.distinct

      # Set the timestamps
      ActiveRecord::Base.record_timestamps = false
      post.date = Time.iso8601(b.css('date-posted').attribute('iso').to_s)
      post.created_at = Time.iso8601(b.css('system-date created').attribute('iso').to_s)
      post.updated_at = Time.iso8601(b.css('system-date modified').attribute('iso').to_s)

      # Get the image(s)
      unless b.css('image').empty?
        filename = b.css('image filename').text.to_s
        post.remote_photo_url = image_base + 'posts/' + filename
      end

      post.save
    end
  end
end

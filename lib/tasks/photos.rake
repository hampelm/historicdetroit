namespace :photos do
  desc "Backfill image dimensions for existing photos"
  task backfill_dimensions: :environment do
    photos = Photo.where(image_width: nil).or(Photo.where(image_height: nil))
    total = photos.count
    
    puts "Backfilling dimensions for #{total} photos..."
    
    photos.find_each.with_index do |photo, index|
      if photo.photo.present? && photo.photo.file.present?
        begin
          # Try to get the file path
          path = photo.photo.path
          
          if path && File.exist?(path)
            img = MiniMagick::Image.open(path)
            photo.update_columns(image_width: img.width, image_height: img.height)
            print "."
          else
            # Try URL for remote storage
            url = photo.photo.url
            if url.present?
              img = MiniMagick::Image.open(url)
              photo.update_columns(image_width: img.width, image_height: img.height)
              print "."
            else
              print "?"
            end
          end
        rescue => e
          print "x"
          Rails.logger.warn "Could not read dimensions for Photo #{photo.id}: #{e.message}"
        end
      else
        print "-"
      end
      
      # Progress update every 100 photos
      if (index + 1) % 100 == 0
        puts " #{index + 1}/#{total}"
      end
    end
    
    puts "\nDone!"
    puts "Photos with dimensions: #{Photo.where.not(image_width: nil).count}"
    puts "Photos without dimensions: #{Photo.where(image_width: nil).count}"
  end
end

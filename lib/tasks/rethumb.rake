namespace :rethumb do
  task :architects => :environment do
    Architect.find_each do |a|
      a.photo.recreate_versions! if a.photo?
    end
  end
end

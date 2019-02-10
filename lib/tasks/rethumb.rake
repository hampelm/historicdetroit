namespace :rethumb do
  task :all, [:style] => :environment do |_, args|
    Photo.all.each { |i| i.photo.recreate_versions!(args[:style].to_sym) if i.photo? }
  end

  task :architects => :environment do
    Architect.find_each do |a|
      a.photo.recreate_versions! if a.photo?
    end
  end
end

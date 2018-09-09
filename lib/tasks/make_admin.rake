task :make_admin, [:email] => :environment do |_, args|
  user = User.find(email: args[:email])
  user.admin = true
  user.save
end

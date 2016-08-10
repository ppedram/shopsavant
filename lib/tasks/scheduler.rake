desc "This task is called by the Heroku scheduler add-on"
task :update_products => :environment do
  puts "Updating products..."
  Product.scanAll
  puts "done."
end
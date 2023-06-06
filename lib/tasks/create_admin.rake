namespace :admin do
  desc "Creates admin without confirmation"
  task make_admin: :environment do
    print "Enter name: "
    name = STDIN.gets.chomp
    print "Enter email: "
    email = STDIN.gets.chomp
    password = STDIN.getpass("Enter Password: ")
    u = User.new(name: name, email: email, password: password, role: 'admin')
    u.skip_confirmation!
    if u.save
      puts "\nNew admin user created"
    else
      puts "\nFailed to save new admin user"
      puts "Errors: #{u.errors.to_a}"
    end
  end
end

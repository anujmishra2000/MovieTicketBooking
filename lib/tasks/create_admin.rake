namespace :admin do
  desc "Creates admin without confirmation"
  task make_admin: :environment do
    print "Enter email: "
    email = STDIN.gets.chomp
    # print "Enter password: "
    password = STDIN.getpass("Enter Password: ")

    # password = STDIN.noecho(&:gets).chomp
    u = User.new(email: email, password: password, role: 'admin')
    u.skip_confirmation!
    if u.save
      puts "\nNew admin user created"
    else
      puts "\nFailed to save new admin user"
    end
  end
end

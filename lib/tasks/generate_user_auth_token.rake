desc "Generates User Auth Token"
namespace :user do
  task generate_user_auth_token: :environment do
    User.where(auth_token: nil).where.not(confirmed_at:nil).each do |user|
      user.assign_auth_token
    end
  end
end

FactoryBot.define do
  factory :movie do
    before(:create) do |movie|
      movie.poster.attach(io: File.open("#{Rails.root}/spec/support/images/infinity.jpg"), filename: 'infinity.jpg')
    end
    title { FFaker::Name.name }
    description { FFaker::Lorem.sentence(20) }
    release_date { '2023-08-10' }
    duration_in_mins { FFaker::Number.number(digits: 2) }
    status { 'live' }
  end
end

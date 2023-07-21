FactoryBot.define do
  factory :movie do
    before(:create) do |movie|
      movie.poster.attach(io: File.open("#{Rails.root}/spec/support/images/infinity.jpg"), filename: 'infinity.jpg')
    end
    sequence(:title) { |n|  "movie #{n}" }
    description { 'AntMan is a 2015 American superhero film based on the Marvel Comics characters of the same name Scott Lang and Hank Pym. Produced by Marvel Studios and distributed by Walt Disney Studios Motion Pictures, it is the 12th film in the Marvel Cinematic Universe.' }
    release_date { Date.current }
    duration_in_mins { 180 }
    status { 'live' }
  end
end

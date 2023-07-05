module Tokenizable
  extend ActiveSupport::Concern

  def generate_token(purpose)
    token = nil
    loop do
      token = SecureRandom.base58
      break unless self.class.find_by("#{purpose}_token" => token)
    end
    token
  end
end

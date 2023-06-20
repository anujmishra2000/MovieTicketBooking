module Numberable
  extend ActiveSupport::Concern

  def generate_number(letter, length)
    self.number = letter + SecureRandom.random_number(10**(length-1)...10**length).to_s
    if self.class.exists?(number: number)
      generate_number(letter, length)
    end
  end
end

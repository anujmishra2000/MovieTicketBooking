module Numberable
  extend ActiveSupport::Concern
  included do
    validates :number, presence: true, uniqueness: true
    before_validation :set_number, on: :create
    singleton_class.attr_accessor :letter, :length
  end

  def set_number
    self.number = generate_number
  end

  def generate_number
    letter = self.class.letter
    length = self.class.length
    loop do
      range = 10**(length-1)...10**length
      number = letter + SecureRandom.random_number(range).to_s
      return number unless self.class.exists?(number: number)
      length += 1 if self.class.count >= range.count
    end
  end

  class_methods do
    def set_number(letter:, length:)
      @letter = letter
      @length = length
    end
  end
end

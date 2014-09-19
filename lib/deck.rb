require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    Card::SUIT_STRINGS.keys.each do |suit|
      Card::VALUE_STRINGS.keys.each do |value|
        @cards << Card.new(suit, value)
      end
    end

    @cards.shuffle!
  end

  def take(n)
    @cards.shift(n)
  end

  def count
    @cards.count
  end

end
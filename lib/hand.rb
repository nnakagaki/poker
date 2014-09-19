require "deck"

class Hand
  attr_reader :cards

  def self.init_draw(deck)
    deck.take(5)
  end

  def initialize(deck)
    @cards = Hand.init_draw(deck)
    @deck = deck
  end

  def discard(indices)
    indices.each do |index|
      @cards[index] = @deck.take(1)
    end
  end

  def type

    return :straight_flush if flush? && straight?
    return :flush if flush?
    return :straight if straight?

  end

  def straight?
    count = 1
    values = @cards.map { |card| card.value }
    count = 2 if values.include?(:ace)

    count.times do |round|
      point_values = @cards.map do |card|
        if card.value == :ace
          card.value_num[round]
        else
          card.value_num
        end
      end

      point_values.sort!
      4.times do |index|
        break unless point_values[index] + 1 == point_values[index + 1]
        return true if index == 3
      end
    end

    false
  end

  def flush?
    suits = @cards.map { |card| card.suit }
    suits.all? { |suit| suit == suits[0] }
  end

  def pair_count

  end
end
require "deck"

class Hand
  HAND_STRENGTH = {
    nothing: 0,
    pair: 1,
    three_of_a_kind: 2,
    two_pair: 3,
    straight: 4,
    flush: 5,
    full_house: 6,
    four_of_a_kind: 7,
    straight_flush: 8,
    royal_flush: 9
  }

  SUIT_STRENGTH = {
    diamonds: 0,
    clubs: 1,
    hearts: 2,
    spades: 3
  }

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
    values = @cards.map { |card| card.value }
    if flush? && straight? && values.include?(:ace) && values.include?(:king)
      return :royal_flush
    end
    return :straight_flush if flush? && straight?
    return :flush if flush?
    return :straight if straight?
    pair_count
  end

  def beats?(other_hand)
    return true if HAND_STRENGTH[self.type] > HAND_STRENGTH[other_hand.type]
    return false if HAND_STRENGTH[self.type] < HAND_STRENGTH[other_hand.type]

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
    groups = Hash.new(0)
    @cards.each { |card| groups[card.value] += 1 }
    return :four_of_a_kind if groups.values.include?(4)
    return :full_house if groups.values.include?(3) && groups.values.include?(2)
    return :three_of_a_kind if groups.values.include?(3)

    counter = 0
    groups.values.each do |value|
      counter += 1 if value == 2
    end

    return :two_pair if counter == 2
    return :pair if counter == 1
    return :nothing
  end
end
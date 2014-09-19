require "deck"
require "card"

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
    p my_power = determine_power(self).sort!.reverse
    p their_power = determine_power(other_hand).sort!.reverse

    a = my_power.count

    4.times do |index1|
      a.times do |index2|
        p my_power[index2][index1]
        return true if my_power[index2][index1] > their_power[index2][index1]
        return false if my_power[index2][index1] < their_power[index2][index1]
      end
    end
  end

  def determine_power(the_hand)
    hand_strength = HAND_STRENGTH[the_hand.type]
    p the_cards = the_hand.cards
    groups = Hash.new([])
    the_cards.each { |card| groups[card.value] += [card] }
    power = []
    groups.keys.each do |card_val|
      if card_val == :ace && the_hand.straight? &&  groups.keys.include?(:three)
        card_val_num = Card::VALUE_NUMBERS[card_val][0]
      elsif card_val == :ace
        card_val_num = Card::VALUE_NUMBERS[card_val][1]
      else
        card_val_num = Card::VALUE_NUMBERS[card_val]
      end
      power << [hand_strength, groups[card_val].count, card_val_num, SUIT_STRENGTH[groups[card_val][0].suit]]
    end

    power
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
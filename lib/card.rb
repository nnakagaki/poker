class Card
  SUIT_STRINGS = {
      :clubs    => "♣",
      :diamonds => "♦",
      :hearts   => "♥",
      :spades   => "♠"
    }

  VALUE_STRINGS = {
      :deuce => "2",
      :three => "3",
      :four  => "4",
      :five  => "5",
      :six   => "6",
      :seven => "7",
      :eight => "8",
      :nine  => "9",
      :ten   => "10",
      :jack  => "J",
      :queen => "Q",
      :king  => "K",
      :ace   => "A"
    }

  VALUE_NUMBERS = {
        :deuce => 2,
        :three => 3,
        :four  => 4,
        :five  => 5,
        :six   => 6,
        :seven => 7,
        :eight => 8,
        :nine  => 9,
        :ten   => 10,
        :jack  => 11,
        :queen => 12,
        :king  => 13,
        :ace   => [1, 14]
    }

  attr_reader :suit, :value

  def initialize(suit, value)
    @suit, @value = suit, value
  end

  def ==(other_card)
    (self.suit == other_card.suit) && (self.value == other_card.value)
  end

  def value_num
    VALUE_NUMBERS[value]
  end

  def inspect
    "#{suit}, #{value}"
  end
end
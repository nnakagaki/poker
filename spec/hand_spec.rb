require "hand"
require "rspec"

describe Hand do
  let(:deck) { Deck.new }
  subject(:hand) { Hand.new(deck) }

  it "draws 5 cards at the beginning" do
    expect(hand.cards.count).to eq(5)
    expect(deck.count).to eq(47)
  end

  it "discards up to three cards" do
    previous_hand = hand.cards.dup
    hand.discard([0, 2, 4])
    expect(hand.cards).to_not eq(previous_hand)
    expect(hand.cards).to include(previous_hand[1], previous_hand[3])
  end

  it "draws however many cards were discarded" do
    hand.discard([0, 2, 4])
    expect(hand.cards.count).to eq(5)
  end

  describe "determine what kind of hand it is" do
    class Hand
      attr_writer :cards
    end

    it "identifies royal flush" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:clubs, :king)
      c = Card.new(:clubs, :queen)
      d = Card.new(:clubs, :jack)
      e = Card.new(:clubs, :ten)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:royal_flush)
    end

    it "identifies straight flush" do
      a = Card.new(:clubs, :king)
      b = Card.new(:clubs, :queen)
      c = Card.new(:clubs, :jack)
      d = Card.new(:clubs, :ten)
      e = Card.new(:clubs, :nine)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:straight_flush)
    end

    it "identifies four-of-a-kind" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:spades, :ace)
      c = Card.new(:diamonds, :ace)
      d = Card.new(:hearts, :ace)
      e = Card.new(:clubs, :nine)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:four_of_a_kind)
    end

    it "identifies full house" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:spades, :ace)
      c = Card.new(:diamonds, :ace)
      d = Card.new(:hearts, :nine)
      e = Card.new(:clubs, :nine)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:full_house)
    end

    it "identifies flush" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:clubs, :seven)
      c = Card.new(:clubs, :king)
      d = Card.new(:clubs, :deuce)
      e = Card.new(:clubs, :nine)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:flush)
    end

    it "identifies straight" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:spades, :deuce)
      c = Card.new(:diamonds, :three)
      d = Card.new(:hearts, :four)
      e = Card.new(:clubs, :five)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:straight)
    end

    it "identifies two pair" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:spades, :ace)
      c = Card.new(:diamonds, :nine)
      d = Card.new(:hearts, :ten)
      e = Card.new(:clubs, :nine)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:two_pair)
    end

    it "identifies three-of-a-kind" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:spades, :ace)
      c = Card.new(:diamonds, :ace)
      d = Card.new(:hearts, :ten)
      e = Card.new(:clubs, :nine)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:three_of_a_kind)
    end

    it "identifies pair" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:spades, :ace)
      c = Card.new(:diamonds, :ten)
      d = Card.new(:hearts, :eight)
      e = Card.new(:clubs, :nine)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:pair)
    end

    it "identifies high card (hand of nothing)" do
      a = Card.new(:clubs, :ace)
      b = Card.new(:spades, :ten)
      c = Card.new(:diamonds, :king)
      d = Card.new(:hearts, :jack)
      e = Card.new(:clubs, :nine)
      hand.cards = [a, b, c, d, e]

      expect(hand.type).to eq(:nothing)
    end
  end

  describe "determines if it beats another hand" do

    it "royal flush beats full house" do
      royal_flush = Hand.new(deck)
      full_house = Hand.new(deck)

      a = Card.new(:clubs, :ace)
      b = Card.new(:clubs, :king)
      c = Card.new(:clubs, :queen)
      d = Card.new(:clubs, :jack)
      e = Card.new(:clubs, :ten)
      royal_flush.cards = [a, b, c, d, e]

      a = Card.new(:clubs, :ace)
      b = Card.new(:spades, :ace)
      c = Card.new(:diamonds, :ace)
      d = Card.new(:hearts, :nine)
      e = Card.new(:clubs, :nine)
      full_house.cards = [a, b, c, d, e]

      expect(royal_flush.beats?(full_house)).to be true
    end

    it "full house of 10's over 2's beats full house of 3's over 4's" do
      hand1 = Hand.new(deck)
      hand2 = Hand.new(deck)

      a = Card.new(:clubs, :three)
      b = Card.new(:diamonds, :three)
      c = Card.new(:hearts, :three)
      d = Card.new(:spades, :four)
      e = Card.new(:clubs, :four)
      hand1.cards = [a, b, c, d, e]

      a = Card.new(:clubs, :ten)
      b = Card.new(:spades, :ten)
      c = Card.new(:diamonds, :ten)
      d = Card.new(:hearts, :deuce)
      e = Card.new(:clubs, :deuce)
      hand2.cards = [a, b, c, d, e]

      expect(hand1.beats?(hand2)).to be false
    end

    it "two pair of 10's and 5's beats two pair of 10's and 4's" do
      hand1 = Hand.new(deck)
      hand2 = Hand.new(deck)

      a = Card.new(:hearts, :ten)
      b = Card.new(:diamonds, :ten)
      c = Card.new(:hearts, :three)
      d = Card.new(:spades, :four)
      e = Card.new(:clubs, :four)
      hand1.cards = [a, b, c, d, e]

      a = Card.new(:clubs, :ten)
      b = Card.new(:spades, :ten)
      c = Card.new(:diamonds, :three)
      d = Card.new(:hearts, :five)
      e = Card.new(:clubs, :five)
      hand2.cards = [a, b, c, d, e]

      expect(hand1.beats?(hand2)).to be false
    end

    it "nothing of K,Q,J,10,3 beats nothing of K,Q,J,10,2" do
      hand1 = Hand.new(deck)
      hand2 = Hand.new(deck)

      a = Card.new(:hearts, :king)
      b = Card.new(:diamonds, :queen)
      c = Card.new(:hearts, :jack)
      d = Card.new(:spades, :ten)
      e = Card.new(:clubs, :three)
      hand1.cards = [a, b, c, d, e]

      a = Card.new(:clubs, :king)
      b = Card.new(:spades, :queen)
      c = Card.new(:diamonds, :jack)
      d = Card.new(:hearts, :ten)
      e = Card.new(:clubs, :deuce)
      hand2.cards = [a, b, c, d, e]

      expect(hand1.beats?(hand2)).to be true
    end

    it "suits beat each other in flushes" do
      hand1 = Hand.new(deck)
      hand2 = Hand.new(deck)

      a = Card.new(:hearts, :king)
      b = Card.new(:hearts, :queen)
      c = Card.new(:hearts, :jack)
      d = Card.new(:hearts, :ten)
      e = Card.new(:hearts, :three)
      hand1.cards = [a, b, c, d, e]

      a = Card.new(:clubs, :king)
      b = Card.new(:clubs, :queen)
      c = Card.new(:clubs, :jack)
      d = Card.new(:clubs, :ten)
      e = Card.new(:clubs, :three)
      hand2.cards = [a, b, c, d, e]

      expect(hand1.beats?(hand2)).to be true
    end

    it "looks at kicker for pairs and two-pairs" do
      hand1 = Hand.new(deck)
      hand2 = Hand.new(deck)

      a = Card.new(:hearts, :king)
      b = Card.new(:diamonds, :king)
      c = Card.new(:clubs, :jack)
      d = Card.new(:spades, :jack)
      e = Card.new(:spades, :three)
      hand1.cards = [a, b, c, d, e]

      a = Card.new(:clubs, :king)
      b = Card.new(:spades, :king)
      c = Card.new(:diamonds, :jack)
      d = Card.new(:hearts, :jack)
      e = Card.new(:clubs, :three)
      hand2.cards = [a, b, c, d, e]

      expect(hand1.beats?(hand2)).to be true
    end

    it "deals with straight from ace to five" do
      hand1 = Hand.new(deck)
      hand2 = Hand.new(deck)

      a = Card.new(:hearts, :ace)
      b = Card.new(:diamonds, :deuce)
      c = Card.new(:clubs, :three)
      d = Card.new(:spades, :four)
      e = Card.new(:spades, :five)
      hand1.cards = [a, b, c, d, e]

      a = Card.new(:clubs, :deuce)
      b = Card.new(:spades, :three)
      c = Card.new(:diamonds, :four)
      d = Card.new(:hearts, :five)
      e = Card.new(:clubs, :six)
      hand2.cards = [a, b, c, d, e]

      expect(hand1.beats?(hand2)).to be false
    end

  end

end
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

  it "determines if it beats another hand"

end
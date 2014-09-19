require "deck"
require 'rspec'

describe Deck do
  subject(:deck) { Deck.new }

  it "initializes a shuffled deck with 52 cards" do
    deck1, deck2 = Deck.new, Deck.new

    expect(deck1.cards).to_not eq(deck2.cards)
    expect(deck.cards.count).to eq(52)
  end

  it "takes cards from top of deck" do
    first_five = deck.cards[0..4]
    expect(deck.take(5)).to eq(first_five)
  end

  it "removes taken cards from the deck" do
    deck.take(5)
    expect(deck.cards.count).to eq(47)
  end

  it "counts number of cards remaining" do
    deck.take(10)
    expect(deck.count).to eq(42)
  end

end
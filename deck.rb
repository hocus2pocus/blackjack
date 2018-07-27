class Deck
  SUIT = ['♥', '♦', '♣', '♠']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  attr_reader :deck

  def initialize
    @deck = []
  end

  def generate_deck
    SUIT.each do |suit|
      @deck << CARDS.map { |card| card + suit }
    end
    @deck.flatten!.shuffle!
  end

  def lose_cards(quantity)
    cards = @deck.take(quantity)
    @deck = @deck.drop(quantity)
    cards
  end
end

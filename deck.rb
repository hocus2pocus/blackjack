class Deck
  SUIT = ['♥', '♦', '♣', '♠']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  attr_reader :deck

  def initialize
    @deck = []
  end

  def generate_deck
    SUIT.each do |suit|
      CARDS.each do |rank|
        @deck << Card.new(suit, rank)
      end
    end
    @deck.shuffle!
  end

  def lose_cards(quantity)
    @deck.shift(quantity)
  end
end

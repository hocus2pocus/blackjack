class Card
  attr_reader :suit, :rank, :cost

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def card_view
    " #{@suit} #{@rank} "
  end
end


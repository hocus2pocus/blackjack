class Player
  attr_accessor @hand
  attr_reader @player_name, @bank

  def initialize(player_name)
    @player_name = player_name
    @bank = 100
    @hand = []
  end

  def place_a_bet
    bet = 10
    @bank -= bet
  end

  def take_cards

  end


end

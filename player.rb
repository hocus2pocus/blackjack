class Player
  attr_accessor :hand, :bank
  attr_reader :player_name

  def initialize(player_name, bank)
    @player_name = player_name
    @bank = bank
    @hand = []
  end

  def place_a_bet(bet)
    @bank -= bet
  end
end

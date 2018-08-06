class GameBank
attr_reader :con

  def initialize
    @con = 0
  end

  def place_a_bet(bet, *players)
    players.each do |player|
      player.give_money(bet)
      @con += bet
    end
  end

  def bet_refund(bet, *players)
    players.each do |player|
      player.take_money(bet)
      @con -= bet
    end
  end

  def winner_reward(player)
    player.take_money(@con)
  end

  def new_con
    @con = 0
  end
end

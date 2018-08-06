require_relative 'scoring.rb'

class Player
  include Scoring

  attr_accessor :hand, :bank
  attr_reader :player_name

  def initialize(player_name, bank)
    @player_name = player_name
    @bank = bank
    @hand = []
  end

  def give_money(bet)
    @bank -= bet
  end

  def take_money(bet)
    @bank += bet
  end
end

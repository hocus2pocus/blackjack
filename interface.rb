require_relative 'playing_field.rb'

class Interface
  include PlayingField
  attr_reader :player, :dealer, :game_bank, :deck
  def initialize
    @game_bank = 0
  end

  def start
    generate_players
    place_a_bet(10)
    generate_deck
    deal

    playing_field
  end

  def generate_players
    puts "Введите имя:"
    print "> "
    @player = Player.new(gets.chomp)
    @dealer = Player.new('Dealer')
  end

  def place_a_bet(bet)
    @player.place_a_bet(bet)
    @dealer.place_a_bet(bet)
    @game_bank += bet*2
  end

  def generate_deck
    @deck = Deck.new
    @deck.generate_deck
  end

  def deal
    @player.hand = @deck.lose_cards(2)
    @dealer.hand = @deck.lose_cards(2)
  end
end

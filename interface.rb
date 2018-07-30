require_relative 'playing_field.rb'

class Interface
  include PlayingField
  attr_reader :player, :dealer, :game_bank, :deck
  def initialize
    @game_bank = 0
  end

  def start
    generate_players unless @player
    bank_check(10)
    place_a_bet(10)
    generate_deck
    deal

    playing_field_hidden
    management
  end

  def next_step(step)
    if @player.hand[2] || @dealer.hand[2]
      puts "Игра кокнчена"
      open_hands
    end

    case step
    when "П"
      dealer_step
    when "Д"
      one_more_card(@player)
    when "О"
      open_hands
    when "Н"
      start
    else
      puts "Неизвестная команда"
      management
    end
  end

  def dealer_step
    score = live_scores(@dealer)

    if score >= 17
      puts "Дилер решил пропустить ход"
      playing_field_hidden
      management
    else
      @dealer.hand << @deck.lose_cards(1)
      @dealer.hand.flatten!
      playing_field_hidden
      management
    end
  end

  def one_more_card(player)
    player.hand << @deck.lose_cards(1)
    player.hand.flatten!
    playing_field_hidden
    puts "Нажмите Enter для передачи хода Дилеру"
    print "> "
    dealer_step if gets
  end

  def open_hands
    playing_field
    management
  end

  def generate_players
    puts "Введите имя:"
    print "> "
    @player = Player.new(gets.chomp)
    @dealer = Player.new('Dealer')
  end

  def bank_check(min_bet)
    [@player, @dealer].each do |player|
      if player.bank < min_bet
        puts "Игрок #{player.player_name} проигрался, у него в банке всего #{player.bank}"
        puts "Выход из игры"
        exit
      end
    end
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

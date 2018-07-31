require_relative 'playing_field.rb'

class Interface
  include PlayingField
  attr_reader :player, :dealer, :game_bank, :deck
  def initialize
    @game_bank = 0
    @bet = 10
  end

  def start
    generate_players unless @player
    bank_check(@bet)
    place_a_bet(@bet)
    generate_deck
    deal

    playing_field_hidden
    management
  end

  def next_step(step)
    if @player.hand[2] && @dealer.hand[2]
      open_hands
    end

    case step
    when "П"
      @game_bank == 0 ? game_over : dealer_step
    when "Д"
      @game_bank == 0 ? game_over : one_more_card(@player)
    when "О"
      @game_bank == 0 ? game_over : open_hands
    when "Н"
      clear_field
      @game_bank != 0 ? game_over : start
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

    if @dealer.hand[2] && @player.hand[2]
      open_hands
    else
      puts "Нажмите Enter для передачи хода Дилеру"
      print "> "
      dealer_step if gets
    end
  end

  def open_hands
    playing_field

    dealer_scores = live_scores(@dealer)
    player_scores = live_scores(@player)
    same_score(dealer_scores, player_scores)
    check_scores(dealer_scores, player_scores)
    winner(dealer_scores, player_scores)
  end

  def same_score(dealer_scores, player_scores)
    if dealer_scores == player_scores
      puts "Победила дружба"
      @dealer.bank += @bet
      @player.bank += @bet
      @game_bank = 0
      management
    end
  end

  def check_scores(dealer_scores, player_scores)
    if dealer_scores > 21 && player_scores > 21
      puts "Дружба проиграла"
      @dealer.bank += @bet
      @player.bank += @bet
      @game_bank = 0
      management
    elsif dealer_scores > 21
      puts "Победил #{@player.player_name}"
      @player.bank += @game_bank
      @game_bank = 0
      management
    elsif player_scores > 21
      puts "Победил #{@dealer.player_name}"
      @dealer.bank += @game_bank
      @game_bank = 0
      management
    end
  end

  def winner(dealer_scores, player_scores)
    if dealer_scores > player_scores
      puts "Победил #{@dealer.player_name}"
      @dealer.bank += @game_bank
      @game_bank = 0
      management
    elsif dealer_scores < player_scores
      puts "Победил #{@player.player_name}"
      @player.bank += @game_bank
      @game_bank = 0
      management
    end
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

  def clear_field
    @dealer.hand = []
    @player.hand = []
    @deck = []
  end

  def game_over
    puts "Игра окончена"
  end
end

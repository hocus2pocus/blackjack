require_relative 'playing_field.rb'
require_relative 'constants.rb'
require_relative 'interface_support.rb'

class Interface
  include PlayingField
  include Constants
  include InterfaceSupport

  attr_accessor :open_hands
  attr_reader :player, :dealer, :game_bank, :deck

  def initialize
    @game_bank = 0
    @bet = BET
    @open_hands = 0
  end

  def start
    generate_players
    bank_check(@bet)
    place_a_bet(@bet)
    generate_deck
    deal

    playing_field_hidden
    next_step(next_step(management))
  end

  def next_step(step)
    open_hands_forced

    case step
    when "П"
      @open_hands == 1 ? game_over : dealer_step
    when "Д"
      @open_hands == 1 ? game_over : one_more_card(@player)
      dealer_step if dealer_step_give
    when "О"
      @open_hands == 1 ? game_over : open_hands
    when "Н"
      clear_field
      @open_hands == 1 ? game_over : start
    else
      unknown_command
      next_step(management)
    end
  end

  def dealer_step
    score = live_scores(@dealer)

    if score >= DEALER_DECISION
      dealer_step_skip
      playing_field_hidden
      next_step(management)
    else
      one_more_card(@dealer)
      next_step(management)
    end
  end

  def one_more_card(player)
    player.hand << @deck.lose_cards(1)
    player.hand.flatten!
    playing_field_hidden

    open_hands_forced
  end

  def open_hands_forced
    if @player.hand[2] && @dealer.hand[2]
      open_hands
    end
  end

  def open_hands
    @open_hands = 1
    playing_field

    dealer_scores = live_scores(@dealer)
    player_scores = live_scores(@player)
    same_score(dealer_scores, player_scores)
    check_scores(dealer_scores, player_scores)
    winner(dealer_scores, player_scores)
  end

  def live_scores(player)
    scores = 0

    player.hand.each do |card|
      score = card[0]

      if score.to_i >= 2
        scores += score.to_i
      elsif ['1', 'J', 'Q', 'K'].include?(score)
        scores += 10
      else
        scores <= 10 ? scores += 11 : scores += 1
      end
    end
    scores
  end

  def same_score(dealer_scores, player_scores)
    if dealer_scores == player_scores
      standoff
      bet_refund
      next_step(management)
    end
  end

  def check_scores(dealer_scores, player_scores)
    if dealer_scores > WIN_LIMIT && player_scores > WIN_LIMIT
      standoff
      bet_refund
      next_step(management)
    elsif dealer_scores > WIN_LIMIT
      winner_name(@player)
      next_step(management)
    elsif player_scores > WIN_LIMIT
      winner_name(@dealer)
      next_step(management)
    end
  end

  def winner(dealer_scores, player_scores)
    if dealer_scores > player_scores
      reward(@dealer)
      next_step(management)
    elsif dealer_scores < player_scores
      reward(@player)
      next_step(management)
    end
  end

  def reward(player)
    winner_name(player)
    player.bet_refund(@game_bank)
  end

  def generate_players
    return @player if @player
    @player = Player.new(name_getter, PLAYER_BANK)
    @dealer = Player.new('Dealer', PLAYER_BANK)
  end

  def bank_check(min_bet)
    [@player, @dealer].each do |player|
      if player.bank < min_bet
        out_of_money(player)
      end
    end
  end

  def place_a_bet(bet)
    @player.place_a_bet(bet)
    @dealer.place_a_bet(bet)
    @game_bank += bet*2
  end

  def bet_refund
    @player.bet_refund(bet)
    @dealer.bet_refund(bet)
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
    @game_bank = 0
    @open_hands = 0
  end
end

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
    @game_bank = GameBank.new
    @bet = BET
    @hands_are_open = 0
  end

  def start
    generate_players unless @player
    player_bank_check(@bet)
    @game_bank.place_a_bet(@bet, @player, @dealer)
    generate_deck
    deal

    playing_field_hidden
    next_step(management)
  end

  def next_step(step)
    open_hands_forced unless @hands_are_open == 1

    case step
    when "П"
      game_state_error
      dealer_step
    when "Д"
      game_state_error
      one_more_card(@player)
      dealer_step if dealer_step_give
    when "О"
      game_state_error
      open_hands
    when "Н"
      clear_field
      start
    else
      unknown_command
      next_step(management)
    end
  end

  def game_state_error
    if @hands_are_open == 1
      error_message
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

  def both_players_has_three_cards?
    @player.hand[2] && @dealer.hand[2]
  end

  def open_hands_forced
    open_hands if both_players_has_three_cards?
  end

  def open_hands
    @hands_are_open = 1
    playing_field

    dealer_scores = live_scores(@dealer)
    player_scores = live_scores(@player)
    same_score(dealer_scores, player_scores)
    check_scores(dealer_scores, player_scores)
    winner(dealer_scores, player_scores)
  end

  def live_scores(player)
    player.card_cost(player.hand)
  end

  def same_score(dealer_scores, player_scores)
    if dealer_scores == player_scores
      standoff
      @game_bank.bet_refund(@bet, @player, @dealer)
      next_step(management)
    end
  end

  def check_scores(dealer_scores, player_scores)
    if dealer_scores > WIN_LIMIT && player_scores > WIN_LIMIT
      standoff
      @game_bank.bet_refund(@bet, @player, @dealer)
      next_step(management)
    elsif dealer_scores > WIN_LIMIT
      reward(@player)
      next_step(management)
    elsif player_scores > WIN_LIMIT
      reward(@dealer)
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
    @game_bank.winner_reward(player)
  end

  def generate_players
    @player = Player.new(name_getter, PLAYER_BANK)
    @dealer = Player.new('Dealer', PLAYER_BANK)
  end

  def player_bank_check(min_bet)
    [@player, @dealer].each do |player|
      out_of_money(player) if player.bank < min_bet
    end
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
    @game_bank.new_con
    @hands_are_open = 0
  end
end

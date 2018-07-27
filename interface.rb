class Interface
  attr_reader @player, @dealer, @game_bank
  def initialize
    @game_bank = 0
  end

  def start

    generate_players


    playing_field
  end

  def generate_players
    puts "Введите имя:"
    print "> "
    @player = Player.new(gets.chomp)
    @dealer = Player.new('Dealer')
  end
end

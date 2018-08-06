module PlayingField
  def playing_field
    puts ""
    puts "Игра окончена, руки игроков открыты. Идёт подсчет очков"
    puts ""
    puts "Банк партии: #{@game_bank.con}"
    puts "-----------------------------------------"
    puts "Игрок 1: '#{@dealer.player_name}' || Очков: #{live_scores(@dealer)} || В банке: #{@dealer.bank}"
    @dealer.hand.each { |card| print "|  #{card.card_view}  |" }
    puts ""
    puts "-----------------------------------------"
    puts ""
    puts "-----------------------------------------"
    @player.hand.each { |card| print "|  #{card.card_view}  |" }
    puts ""
    puts "Игрок 2: '#{@player.player_name}' || Очков: #{live_scores(@player)} || В банке: #{@player.bank}"
    puts "-----------------------------------------"
  end

  def playing_field_hidden
    puts ""
    puts ""
    puts "Банк партии: #{@game_bank.con}"
    puts "-----------------------------------------"
    puts "Игрок 1: '#{@dealer.player_name}' || Очков: *** || В банке: #{@dealer.bank}"
    print "|  ***  ||  ***  |"# карты

    if @dealer.hand[2]
      puts "|  ***  |"
    else
      puts ""
    end

    puts "-----------------------------------------"
    puts ""
    puts "-----------------------------------------"
    @player.hand.each { |card| print "|  #{card.card_view}  |" }
    puts ""
    puts "Игрок 2: '#{@player.player_name}' || Очков: #{live_scores(@player)} || В банке: #{@player.bank}"
    puts "-----------------------------------------"
  end

  def management
    print "Управление: "
    print "| (П)ропустить ход |" unless @hands_are_open == 1
    print "| (Д)обавить карту |" unless @player.hand[2] || @hands_are_open == 1
    print "| (О)ткрыть карты |" unless @hands_are_open == 1
    print "| (Н)овая игра |" if @hands_are_open == 1
    puts ""
    print "> "
    gets.chomp.upcase
  end
end

module PlayingField
  def playing_field
    puts ""
    puts ""
    puts "Банк партии: #{@game_bank}"
    puts "-----------------------------------------"
    puts "Игрок 1: '#{@dealer.player_name}' || Очков: #{live_scores(@dealer)} || В банке: #{@dealer.bank}"
    puts "|  #{@dealer.hand[0]}  |  #{@dealer.hand[1]}  |  #{@dealer.hand[2]}" # карты
    puts "-----------------------------------------"
    puts ""
    puts "-----------------------------------------"
    puts "|  #{@player.hand[0]}  |  #{@player.hand[1]}  |  #{@player.hand[2]}" # карты
    puts "Игрок 2: '#{@player.player_name}' || Очков: #{live_scores(@player)} || В банке: #{@player.bank}"
    puts "-----------------------------------------"
  end

  def playing_field_hidden
    puts ""
    puts ""
    puts "Банк партии: #{@game_bank}"
    puts "-----------------------------------------"
    puts "Игрок 1: '#{@dealer.player_name}' || Очков: *** || В банке: #{@dealer.bank}"
    print "|  ***  |  ***  | "# карты

    if @dealer.hand[2]
      puts "***  |"
    else
      puts ""
    end

    puts "-----------------------------------------"
    puts ""
    puts "-----------------------------------------"
    puts "|  #{@player.hand[0]}  |  #{@player.hand[1]}  |  #{@player.hand[2]}" # карты
    puts "Игрок 2: '#{@player.player_name}' || Очков: #{live_scores(@player)} || В банке: #{@player.bank}"
    puts "-----------------------------------------"
  end

  def management
    print "Управление: "
    print "| (П)ропустить ход |" unless @game_bank == 0
    print "| (Д)обавить карту |" unless @player.hand[2] || @game_bank == 0
    print "| (О)ткрыть карты |" unless @game_bank == 0
    print "| (Н)овая игра |" if @game_bank == 0
    puts ""
    print "> "
    next_step(gets.chomp)
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
end

module PlayingField
  def playing_field
    puts ""
    puts "Банк партии: #{@game_bank}"
    puts "-----------------------------------------"
    puts "Игрок 1: '#{@dealer.player_name}' || Очков: #{live_scores(@dealer)} || В банке: #{@dealer.bank}"
    puts "|  #{@dealer.hand[0]}  |  #{@dealer.hand[1]}  |  #{@dealer.hand[2]}" # карты
    puts "-----------------------------------------"
    puts ""
    puts ""
    puts "-----------------------------------------"
    puts "|  #{@player.hand[0]}  |  #{@player.hand[1]}  |  #{@player.hand[2]}" # карты
    puts "Игрок 2: '#{@player.player_name}' || Очков: #{live_scores(@player)} || В банке: #{@player.bank}"
    puts "-----------------------------------------"
    puts #управление
    print "> "
    puts ""
  end

  def live_scores(player)
    scores = 0

    player.hand.each do |card|
      score = card[0]

      if score.to_i >= 2
        scores += score.to_i
      elsif ['10', 'J', 'Q', 'K'].include?(score)
        scores += 10
      else
        scores += 11 if scores <= 10
        scores += 1 if scores >= 10
      end
    end
    scores
  end
end

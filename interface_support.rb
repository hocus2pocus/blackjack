module InterfaceSupport
  def unknown_command
    puts "Неизвестная команда"
  end

  def error_message
    puts "Руки игроков открыты, выбранная команда недоступна"
  end

  def dealer_step_skip
    puts "Дилер решил пропустить ход"
  end

  def dealer_step_give
    puts "Нажмите Enter для передачи хода Дилеру"
    print "> "
    gets
  end

  def winner_name(player)
    puts "Победил #{player.player_name}"
  end

  def standoff
    puts "Ничья"
  end

  def game_over
    puts "Игра окончена"
  end

  def name_getter
    puts "Введите имя:"
    print "> "
    gets.chomp
  end

  def out_of_money(player)
    puts "Игрок #{player.player_name} проигрался, у него в банке всего #{player.bank}"
    puts "Выход из игры"
    exit
  end
end

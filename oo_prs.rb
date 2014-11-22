#oo_prs.rb

class PlayerHand
  include Comparable
  attr_reader :name, :choice

  def <=>(another_player)
    if self.choice == another_player.choice
      0
    elsif (self.choice == 'r' && another_player.choice == 's') || (self.choice == 's' && another_player.choice == 'p') ||
      (self.choice == 'p' && another_player.choice == 'r')
      1
    else
      -1
    end
  end

  def initialize(n)
    @name = n
  end

  def to_s
    puts "#{name} has selected #{Game::CHOICES[choice]}"
  end

end

class Human < PlayerHand

  def pick_hand
    puts "Hi #{name}, please pick: Rock, Paper, or Scissors. (P/R/S)"
    player_choice = gets.chomp.downcase

    until Game::CHOICES.keys.include?(player_choice)
      puts "Invalid Choice.  Please pick: 'P', 'R', or 'S'"
      player_choice = gets.chomp.downcase
    end
    @choice = player_choice

  end

end

class Computer < PlayerHand 

  def pick_hand
    comp_choice = Game::CHOICES.keys.sample
    @choice = comp_choice
  end

end

class Game
  attr_reader :computer, :player

  CHOICES = { 'r' => "Rock", 's' => "Scissors", 'p' => "Paper"}

  def initialize
    @player = Human.new("Chris")
    @computer = Computer.new("C3PO")
  end

  def compare_hands
    if player == computer
      puts "It's a tie"
    elsif player > computer
      puts "#{player.name} wins"
    else
      puts "#{computer.name} wins"
    end
  end
        

  def play
    player.pick_hand
    computer.pick_hand
    player.to_s
    computer.to_s
    compare_hands
  end
end

Game.new.play
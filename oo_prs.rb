#oo_prs.rb

class Player
  attr_accessor :choice, :name

  def initialize(name)
    @choice = ""
    @name = name
  end
end

def get_user_choice(player)
  puts "Hi #{player.name} choose one: Paper, Rock, or Scissors. (P/R/S)"
  user_choice = gets.chomp.upcase
  until user_choice == 'R' || user_choice == 'P' || user_choice == 'S'
    puts "Invalid input. Acceptable inputs are: P, R, or S"
    puts "Please choose again"
    user_choice = gets.chomp.upcase
  end
  player.choice = user_choice
end

def computer_choice
  choices = ["R", "P", "S"]
  comp_choice = choices.sample
end

def determine_outcome(player, comp_choice)
  if player.choice == comp_choice
    puts "It's a tie!"
  elsif player.choice == 'R' && comp_choice == 'P'
    puts "Sorry #{player.name}, Paper wraps Rock.  You lose this round!"
  elsif player.choice == 'P' && comp_choice == 'S'
    puts "Sorry #{player.name}, Scissors cuts Paper.  You lose this round!"
  elsif player.choice == 'S' && comp_choice == 'R'
    puts "Sorry #{player.name}, Rock smashes Scissors.  You lose this round!"
  elsif player.choice == 'R'
    puts "Congratulations #{player.name}, Rock smashes Scissors.  You win this round"
  elsif player.choice == 'P'
    puts "Congratulations #{player.name}, Paper wraps Rock. You win this round!"
  else
    puts "Congratulations #{player}, Scissors cuts Paper. You win this round!"
  end
end
      
      
puts "Welcome to OO Rock Paper Scissors.  Can we have your name please?"

input = gets.chomp      
      
player = Player.new(input)

begin
  get_user_choice(player)

  comp_choice = computer_choice

  determine_outcome(player, comp_choice)

  puts "Would you like to play again? (Y/N)"

  again = gets.chomp.upcase

end while again == 'Y'



=begin
2 players alternate picking a square on a 3x3 grid.  The game ends when 
no squares are left to pick or when one player has managed to pick
3 squares in a row.

grid is a collection of 9 squares

human is a player
computer is a player
=end

WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

class Square
  attr_accessor :value
  attr_reader :location

  def initialize(location)
    @value = " "
    @location = location
  end

  def to_s
    puts "Im a square, with a value of #{value} and im located at #{location}"
  end
end

class Grid
  attr_accessor :square_hash, :game_board
  def initialize(squares)
    @square_hash = Hash.new

    update_squares(squares)
  end

  def update_squares(squares)
    squares.each do |square|
      square_hash[square.location] = square.value
    end
    @game_board = "
     |     |     
  #{@square_hash[1]}  |  #{@square_hash[2]}  |  #{@square_hash[3]}  
     |     |     
-----+-----+-----
     |     |     
  #{@square_hash[4]}  |  #{@square_hash[5]}  |  #{@square_hash[6]}  
     |     |     
-----+-----+-----
     |     |     
  #{@square_hash[7]}  |  #{@square_hash[8]}  |  #{@square_hash[9]}  
     |     |      "
  end


  def to_s
    puts game_board + "\n\n"
  end

end

class Player
  attr_reader :name

  def initialize(n)
    @name = n
  end

end

class Human < Player
  attr_reader :marker

  def initialize(n)
    super(n)
    @marker = 'X'
  end

  def pick_a_square(squares)
    puts "#{name}, please pick a square to place your marker: (1-9)"
    input = gets.chomp
    until input =~ /^[1-9]$/ && squares[input.to_i-1].value == " "
      puts "Sorry that isn't valid.  Please enter an empty square # 1-9"
      input = gets.chomp
    end
    input.to_i
  end

end

class Computer < Player
  attr_reader :marker

  def initialize(n)
    super(n)
    @marker = 'O'
  end

  def smart_pick(grid)
    WINNING_LINES.each do |line|
      if grid.square_hash[line[0]] == 'O' && grid.square_hash[line[1]] == 'O'  && grid.square_hash[line[2]] == " "
        return line[2]
      elsif grid.square_hash[line[1]] == 'O' && grid.square_hash[line[2]] == 'O' && grid.square_hash[line[0]] == " "
        return line[0]
      elsif grid.square_hash[line[0]] == 'O' && grid.square_hash[line[2]] == 'O' && grid.square_hash[line[1]] == " "
        return line[1]
      end
    end

    WINNING_LINES.each do |line|
      if grid.square_hash[line[0]] == 'X' && grid.square_hash[line[1]] == 'X' && grid.square_hash[line[2]] == " "
        return line[2]
      elsif grid.square_hash[line[1]] == 'X' && grid.square_hash[line[2]] == 'X' && grid.square_hash[line[0]] == " "
        return line[0]
      elsif grid.square_hash[line[0]] == 'X' && grid.square_hash[line[2]] == 'X' && grid.square_hash[line[1]] == " "
        return line[1]
      end
    end
    nil
  end
          
  def pick_a_square(grid)
    if smart_pick(grid)
      return smart_pick(grid)
    else
      empty_spaces = []
      grid.square_hash.each do |k, v|
        if v == " "
          empty_spaces << k
        end
      end
      return empty_spaces.sample
    end
  end

end

class Game
  attr_accessor :squares
  attr_reader :grid, :human, :computer

  def initialize

    @human = Human.new("Chris")
    @computer = Computer.new("C3PO")

    @squares = []
    1.upto(9) do |x|
      square = Square.new(x)
      @squares << square
    end

    @grid = Grid.new(squares)
    grid.to_s
    
  end

  def game_round
    squares[human.pick_a_square(squares)-1].value = human.marker
    grid.update_squares(squares)
    if check_for_winner
      grid.to_s
      puts "#{human.name} wins!"
      return true
    elsif !grid.square_hash.values.include?(" ")
      grid.to_s
      puts "This game is a tie!"
      return true
    else
      squares[computer.pick_a_square(grid)- 1].value = computer.marker
      grid.update_squares(squares)
      grid.to_s
    end
    if check_for_winner
      puts "#{computer.name} wins!"
      true
    else
      nil
    end
  end

  def play
    begin
      winner = game_round
    end until winner
  end

  def check_for_winner
    WINNING_LINES.each do |line|
      if grid.square_hash[line[0]] == human.marker && grid.square_hash[line[1]] == human.marker &&
        grid.square_hash[line[2]] == human.marker
        return true
      elsif grid.square_hash[line[0]] == computer.marker && grid.square_hash[line[1]] == computer.marker &&
        grid.square_hash[line[2]] == computer.marker
        return true
      end
    end
    nil
  end

end

begin
  Game.new.play
  puts "Play again? (Y/N)"
  answer = gets.chomp.upcase
  until answer == "Y" || answer == "N"
    puts "Invalid input. Y or N please."
    answer = gets.chomp.upcase
  end

end until answer == "N"
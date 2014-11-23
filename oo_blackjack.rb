=begin
Black jack is a game played with 1-6 players competing individually to beat
the dealer/house.  Players are dealt cards from a deck until they decide they don't want any more,
or their hand exceeds a value of 21 as determined by the sum of the face values.
After all player hands are resolved, the dealer will continue to take cards until they
have a hand with at least a value of 17.
The winner of any given hand is the player or dealer that comes
closest to 21 without going over it.

Person
- A person has a name or title
-Players
  - Players have a hand containing 2 or more cards
-Dealer
- Dealers have a hand containing 2 or more cards
- Dealers second card reamins hidden until all player hands are resolved
Deck
-Each deck contains 52 cards
-Cards are dealt from the deck
-Decks can be shuffled
Card
-consists of a suit and a value
Game
-The game creates a deck and generates players and dealers
-The game is aware of player hand totals and can calculate them
-The game prompts the player if they would like more cards or would like to stay
-The game is aware if a player has busted
-The game compares hands after all hands are resolved and determines a winner
-The game includes comparable, and has space ship operator method
=end

class Person
  attr_reader :name

  def initialize(n)
    @name = n
  end
end

class Player < Person
  attr_accessor :hands, :current_hand

  def initialize(name)
    super(name)
    @hands = Hash.new
    @current_hand = 1
    hands[current_hand] = []
  end

  def next_hand
    self.current_hand += 1
  end

  def no_more_hands(hand_num)
    self.hands[hand_num].nil? ? true : false
  end

  def to_s
    puts "Hi my name is #{name} and I will be the player!"
  end

end

class Dealer < Person
  attr_accessor :hand

  def initialize(name)
    super(name)
    @hand = []
  end

  def to_s
    puts "Hi my name is #{name} and I will be the dealer!"
  end

end

class Deck
  attr_reader :cards
  
  def initialize
    @cards = []
    ['Clubs', 'Diamonds', 'Hearts', 'Spades'].each do |suit|
      ['2','3','4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |value|
        card = Card.new(value, suit)
        cards << card
      end
    end
  end

  def shuffle
    cards.shuffle!
  end

  def deal_card
    cards.pop
  end
end

class Card
  include Comparable
  attr_reader :suit, :value

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def tens_card?
    ["10", "Jack", "Queen", "King"].include?(value) ? true : false
  end

  def card_value
    if value == "Ace"
      return 11
    elsif tens_card?
      return 10
    else
      return value.to_i
    end
  end

  def <=>(another_card)
    if card_value > another_card.card_value
      1
    elsif card_value == another_card.card_value
      0
    else
      -1
    end
  end

  def to_s
    puts "#{self.value} of #{self.suit}"
  end
end

class Game
  attr_accessor :player, :dealer, :deck

  def initialize
    system 'clear'
    @player = Player.new("Chris")
    @dealer = Dealer.new("Flamingo")
    puts dealer.to_s
    sleep 2
    @deck = Deck.new
  end

  def eligible_to_split?(hand)
    (hand.size == 2 && hand[0] == hand[1]) ? true : false
  end

  def split_hand
    counter = 1
    loop do
      if player.no_more_hands(player.current_hand+counter)
        player.hands[player.current_hand+counter] = [player.hands[player.current_hand].pop]
        add_card_to_hand(player.hands[player.current_hand])
        add_card_to_hand(player.hands[player.current_hand+counter])
        break
      else
        counter += 1
      end
    end
  end

  def add_card_to_hand(hand)
    hand << deck.deal_card
  end

  def player_turn
    begin
      value_check = calculate_hand_value(player.hands[player.current_hand])
      if value_check == 21
        choice = 's'
        puts "Congratulations Hand #{player.current_hand} has a Black Jack!"
        sleep 2
      elsif bust?(value_check)
        puts "Sorry Hand #{player.current_hand} busts!"
        choice = 's'
        sleep 2
      else  
       choice = options_handler(player_options)
      end
      if choice == 's'
        player.next_hand
      end
    end until player.no_more_hands(player.current_hand)
  end

  def dealer_turn
    sleep 1.5
    system 'clear'
    puts "#{dealer.name} reveals their hole card.........."
    sleep 2
    display_cards_in_hand(true)
    draw_hand_value(true)
    sleep 5
    if !all_player_hands_bust? && !all_player_hands_21?
      while calculate_hand_value(dealer.hand) < 17
        system 'clear'
        puts "#{dealer.name}'s' hand is less than 17. They draw a new card........."
        sleep 2
        add_card_to_hand(dealer.hand)
        display_cards_in_hand(true)
        draw_hand_value(true)
        sleep 5
      end
    end
  end

  def all_player_hands_bust?
    bust = true
    player.hands.size.times do |hand_num|
      if !bust?(calculate_hand_value(player.hands[hand_num+1]))
        bust = false
        return bust
      end
    end
    bust
  end

  def all_player_hands_21?
    all_blackjack = true
    player.hands.size.times do |hand_num|
      if calculate_hand_value(player.hands[hand_num+1]) != 21
        all_blackjack = false
        return all_blackjack
      end
    end
    return all_blackjack
  end

  def compare_hands(player_value, dealer_value)
    if bust?(player_value)
      return :c
    elsif bust?(dealer_value)
      return :p
    elsif player_value == dealer_value
      return :u
    elsif player_value > dealer_value
      return :p
    else
      return :c
    end
  end
        
        

  def display_final_outcome
    comp_value = calculate_hand_value(dealer.hand)
    winning_messages = { p: "#{player.name} wins!", c: "#{dealer.name} wins!", u: "It's a push!" }
    system 'clear'
    puts "Displaying Final Outcome....."
    sleep 2
    system 'clear'
    player.hands.size.times do |hand_num|
      player_value = calculate_hand_value(player.hands[hand_num+1])
      puts "*-------------------------------------------------------------*"
      puts "|Your Hand #{hand_num + 1}: #{player_value}         #{winning_messages[compare_hands(player_value, comp_value)]}       #{dealer.name}'s Hand:#{comp_value} |"
      puts "*-------------------------------------------------------------*"
    end
  end

  def play
    deck.shuffle
    add_card_to_hand(player.hands[player.current_hand])
    add_card_to_hand(dealer.hand)
    add_card_to_hand(player.hands[player.current_hand])
    add_card_to_hand(dealer.hand)
    display_cards_in_hand
    draw_hand_value
    if calculate_hand_value(dealer.hand) != 21
      player_turn
      dealer_turn
    else
      puts "Dealer has a Black Jack"
      sleep 5
    end
    display_final_outcome
  end

  def options_handler(option)
    case option
    when 'h'
      add_card_to_hand(player.hands[player.current_hand])
      display_cards_in_hand
      draw_hand_value
      return 'h'
    when 'p'
      split_hand
      display_cards_in_hand
      draw_hand_value
      return 'p'
    else
      return 's'
    end
  end

  def display_cards_in_hand(dealer_active = false)
    
    if dealer_active
      system 'clear'
      puts "#{dealer.name} has the following cards:"
      dealer.hand.each do |card|
        card.to_s
      end
      puts  "\n"
      player.hands.size.times do |hand_num|
        puts "#{player.name}'s Hand #{hand_num + 1} contains: "
        player.hands[hand_num + 1].each do |card|
          card.to_s
        end
        puts  "\n"
      end
    else
      system 'clear'
      puts "#{dealer.name} is showing:"
      dealer.hand[0].to_s
      puts  "\n"
      player.hands.size.times do |hand_num|
        puts "#{player.name}'s Hand #{hand_num + 1} contains: "
        player.hands[hand_num + 1].each do |card|
          card.to_s
        end
        puts  "\n"
      end
    end
  end

  def bust?(hand_value)
    hand_value > 21 ? true : false
  end

  def calculate_hand_value(hand)
    total = 0
    ace_count = 0

    hand.each do |card|
      if card.value == "Ace"
        ace_count += 1
      end
      total += card.card_value
    end

    ace_count.times do
      if bust?(total)
        total -= 10
      end
    end
    total
  end

  def draw_hand_value(dealer_active = false)
    if dealer_active
      player.hands.size.times do |hand_num|
        puts "*-------------------------------------------------------------*"
        puts "|Your Hand #{hand_num + 1}: #{calculate_hand_value(player.hands[hand_num+1])}                           #{dealer.name}'s Hand:#{calculate_hand_value(dealer.hand)} |"
        puts "*-------------------------------------------------------------*"
      end
    else
      player.hands.size.times do |hand_num|
        puts "*-------------------------------------------------------------*"
        puts "|Your Hand #{hand_num + 1}: #{calculate_hand_value(player.hands[hand_num+1])}                            #{dealer.name}'s Hand:#{dealer.hand[0].card_value} |"
        puts "*-------------------------------------------------------------*"
      end
    end
  end

  def player_options
    puts "Hand #{player.current_hand} - Would you like to Hit, Stay or Split?: (H/S/P)"
    input = gets.chomp.downcase
    until ['h','s','p'].include?(input)
      puts "Invalid data entered.  Please enter H, S, or P"
      input = gets.chomp.downcase
    end

    if input == 'p' && eligible_to_split?(player.hands[player.current_hand])
      return input
    elsif input == 'p' && !eligible_to_split?(player.hands[player.current_hand])
      until ['h', 's'].include?(input)
        puts "Sorry this hand is not eliglbe to split, please enter H or S"
        input = gets.chomp.downcase
        until ['h', 's'].include?(input)
          puts "Invalid data entered. Please enter H or S"
          input = gets.chomp.downcase
        end
      end
    end
    input
  end

end

Game.new.play
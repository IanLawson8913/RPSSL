require 'pry'

# class Rock < Move
# end

# class Paper < Move
# end

# class Scissors < Move
# end

# class Spock < Move
# end

# class Lizard < Move
# end

class Player
  attr_accessor :move, :name
  @@move_history = {}

  def initialize
    set_name
    @@move_history[self.name] = []
  end

  def self.move_history
    @@move_history
  end

  def update_history
    Player.move_history[self.name] << @value
  end

  def to_s
    name
  end

  def valid_choice?(choice)
    (Move::WINS.keys.include?(choice) || (1..5).to_a.include?(choice.to_i))
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      print "What's your name? "
      n = gets.chomp
      puts ""
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def convert_input(value)
    if value == value.to_i.to_s
      Move::WINS.keys.each_with_index do |move, idx|
        @value = move if (idx + 1).to_s == value
      end
    else
      Move::WINS.keys.each do |move, idx|
        @value = move if move.start_with?(value)
      end
    end
    binding.pry
  end

  def choose
    choice = nil
    loop do
      puts "Please choose:"
      puts ""
      puts "1) rock,     2) paper"
      puts "3) scissors, 4) spock" 
      puts "5) lizard    6) display move history"
      puts ""
      choice = gets.chomp
      if valid_choice?(choice)
        update_history
        system 'clear'
        break
      end
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(convert_input(choice))
    self.update_history
  end
end

class Computer < Player
  BASE_CHOICES = [0, 1, 2, 3, 4]

  def initialize
    @choices = BASE_CHOICES # - @@move_history[]
  end

  def choose
    self.move = Move.new(Move::WINS.keys[@choices.sample], 'computer')
    self.update_history
  end
end

# I pick rock every time... :/
class Ricky < Computer
  def initialize
    @name = 'Ricky'
    @choices = [0]
  end
end

# I like lizards so I choose lizard %75 of the time
class Bill < Computer
  LIZARD_IDX = 4

  def initialize
    @name = 'Bill'
    @choices = BASE_CHOICES + [LIZARD_IDX] * 16
  end
end

# I pick anything but what you just picked
class Spike < Computer
  def initialize
    @name = 'Spike'
    @choices = BASE_CHOICES 
  end

  def choose
    self.move = Move.new(Move::WINS.keys[0], 'computer')
  end
end

# I pick moves that beat your most chosen move so far this round
class Lucy < Computer
  def initialize
    @name = 'Lucy'
  end

  def most_chosen
    # return most chosen from history
  end

  def choose
    # choose between moves that beat most choosen
  end
end

class RPSGame
  FINAL_SCORE = 2

  attr_accessor :human, :computer, :score, :round_winner, :move_history

  def initialize
    @human = Human.new
    @computer = [Ricky.new, Bill.new].sample
    @score = { human => 0, computer => 0 }
    @round_winner = nil
    # @move_history = { self.human => [], self.computer => [] }
  end

  # Assignment branch condition size too high
  def update_score
    if human.move > computer.move
      self.round_winner = human
      score[round_winner] += 1
    elsif human.move < computer.move
      self.round_winner = computer
      score[round_winner] += 1
    end
  end

  # Possible solution for above:
  # def set_round_winner; end

  def reset_score
    score.each { |player, _| score[player] = 0 }
  end

  # def update_history
  #   self.move_history[self.human] << self.human.move
  #   self.move_history[self.computer] << self.computer.move
  # end

  def endgame_winner?
    score.values.include?(FINAL_SCORE) # too much chaining?
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase[0]
      puts "Invalid input. Must be y or n."
    end

    return true if answer.downcase == 'y'
    return false if answer.downcase == 'n'
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Spock, Lizard!"
    puts "Your opponent's name is #{computer.name}"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    print "#{computer.name} chose"
    sleep 0.2
    print "."
    sleep 0.2
    print "."
    sleep 0.2
    print "."
    sleep 0.2
    puts "#{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_endgame_winner
    if score[human] == score[computer]
      puts "At this point the score results in a tie!"
    else
      puts "#{round_winner} win's the entire game!"
    end
  end

  def display_move_history
    p Player.move_history
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_move_history
      display_moves
      display_winner
      update_score
      endgame_winner? ? display_endgame_winner : next
      play_again? ? reset_score : break
    end

    display_goodbye_message
  end
end

class Move < RPSGame
  # VALUES = ['rock', 'paper', 'scissors', 'spock', 'lizard']
  WINS = { 'rock' => ['scissors', 'lizard'],
           'paper' => ['rock', 'spock'],
           'scissors' => ['paper', 'lizard'],
           'spock' => ['rock', 'scissors'],
           'lizard' => ['paper', 'spock'] }

  # def initialize(value, user='human')
  #   convert_input(value)
  # end

  def >(other_move)
    WINS[@value].include?(other_move.to_s)
  end

  def <(other_move)
    WINS[other_move.to_s].include?(@value)
  end

  def to_s
    @value
  end
end

# class Display < RPSGame
#   def display_welcome_message
#     puts "Welcome to Rock, Paper, Scissors, Spock, Lizard!"
#   end

#   def display_goodbye_message
#     puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Bye!"
#   end

#   def display_moves
#     puts "#{human.name} chose #{human.move}"
#     puts "#{computer.name} chose #{computer.move}"
#   end

#   def display_winner
#     if human.move > computer.move
#       puts "#{human.name} won!"
#     elsif human.move < computer.move
#       puts "#{computer.name} won!"
#     else
#       puts "It's a tie!"
#     end
#   end

#   def display_endgame_winner
#     if score[human] == score[computer]
#       puts "At this point the score results in a tie!"
#     else
#       puts "#{round_winner} win's the entire game!"
#     end
#   end
# end

RPSGame.new.play

# score
# first player to win 10 wins game
# -- loop main game until score of human or comp == 10
# -- output winner

# is score a new class or a new state of an existing class?

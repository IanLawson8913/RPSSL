require 'pry'

class Move
  VALUES = ['rock', 'paper', 'scissors', 'spock', 'lizard']
  WINS = { 'rock' => ['scissors', 'lizard'],
           'paper' => ['rock', 'spock'],
           'scissors' => ['paper', 'lizard'],
           'spock' => ['rock', 'scissors'],
           'lizard' => ['paper', 'spock'] }

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def spock?
    @value == 'spock'
  end

  def lizard?
    @value == 'lizard'
  end

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

  def initialize
    set_name
  end

  def to_s
    name
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, spock, or lizard:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  BASE_CHOICES = [0, 1, 2, 3, 4]

  def initialize
    @choices = BASE_CHOICES
  end

  def choose
    self.move = Move.new(Move::VALUES[@choices.sample])
  end
end

# I pick rock every time... :/
class Ricky < Computer
  def initialize
    @name = 'Ricky'
    @choices = [0]
  end
end

# I pick anything but what you just picked
class Spike < Computer
  def initialize
    @name = 'Spike'
    @choices = BASE_CHOICES # - [what you just picked]
  end

  def choose
    self.move = Move.new(Move::VALUES[0])
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

# I like lizards so I choose lizard %75 of the time
class Bill < Computer
  def initialize
    @name = 'Bill'
    @choices = BASE_CHOICES + [4] * 16
  end
end

class RPSGame
  FINAL_SCORE = 2

  attr_accessor :human, :computer, :score, :round_winner, :move_history

  def initialize
    @human = Human.new
    @computer = [Ricky.new, Spike.new, Lucy.new, Bill.new].sample
    @score = { human => 0, computer => 0 }
    @round_winner = nil
    @move_history = { self.human => [], self.computer => [] }
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Spock, Lizard!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
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

  def update_history
    self.move_history[self.human] << self.human.move
    self.move_history[self.computer] << self.computer.move
  end

  # Possible solution for above error
  def set_winner; end

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

  def endgame_winner?
    score.values.include?(FINAL_SCORE) # too much chaining?
  end

  def reset_score
    score.each { |player, _| score[player] = 0 }
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Invalid input. Must be y or n."
    end

    return true if answer.downcase == 'y'
    return false if answer.downcase == 'n'
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      update_history
      display_moves
      display_winner
      update_score
      endgame_winner? ? display_endgame_winner : next
      play_again? ? reset_score : break
    end

    display_goodbye_message
  end
end

RPSGame.new.play

# score
# first player to win 10 wins game
# -- loop main game until score of human or comp == 10
# -- output winner

# is score a new class or a new state of an existing class?

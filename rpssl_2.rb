require 'pry'

class Player
  @@human_name = ''

  attr_accessor :move, :name, :human_name

  def initialize
    set_name
  end

  def to_s
    name
  end

  def self.human_name
    @@human_name
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
    # Is there a better way to give comp player access to human name?
    Player.human_name << name
  end

  def choose
    choice = nil
    loop do
      display_choices
      choice = gets.chomp
      if chose_display_history?(choice)
        display_move_history
        next
      elsif valid_choice?(choice)
        system 'clear'
        break
      end
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice, self.name)
  end

  def display_choices
    puts "Please choose:"
    puts ""
    puts "1) rock,     2) paper"
    puts "3) scissors  4) spock"
    puts "5) lizard    6) display move history"
    puts ""
  end

  def valid_choice?(choice)
    Move::WINS.keys.any? { |key| key.start_with?(choice) } ||
      (1..6).to_a.include?(choice.to_i)
  end

  def display_move_history
    system 'clear'
    Move.history.keys.each do |player|
      puts "#{player}: " + Move.history[player].last(10).join(', ')
      puts ''
    end
  end

  def chose_display_history?(choice)
    choice == '6' || 'display move history'.start_with?(choice)
  end
end

class Computer < Player
  attr_accessor :choices

  BASE_CHOICES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize
    @choices = BASE_CHOICES
  end

  def choose
    self.move = Move.new(self.choices.sample, self.name)
  end
end

# I pick rock every time... :/
class Ricky < Computer
  def initialize
    @name = 'Ricky'
    @choices = BASE_CHOICES[0, 1]
  end
end

# I pick a random favorite move and use it most of the time
class Bill < Computer
  attr_reader :favorite_move

  def initialize
    @name = 'Bill'
    @favorite_move = BASE_CHOICES.sample
    @choices = BASE_CHOICES + [self.favorite_move] * 5
  end
end

# I pick a counter to your last move
class Spike < Computer
  attr_accessor :round

  def initialize
    super
    @name = 'Spike'
    @round = 0
  end

  def choose
    update_choices if self.round > 1
    super
    self.round += 1
  end

  def update_choices
    last_human_choice = Move.history[Player.human_name][-2]
    counters = Move::LOSES[last_human_choice]
    self.choices = counters
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
end

class RPSGame
  FINAL_SCORE = 10

  attr_accessor :human, :computer, :score, :round_winner

  def initialize
    @human = Human.new
    @computer = [Ricky.new, Bill.new, Spike.new].sample
    @score = { human => 0, computer => 0 }
    @round_winner = nil
  end

  # Assignment branch condition size too high
  def update_score
    if human.move > computer.move
      self.round_winner = human
    elsif human.move < computer.move
      self.round_winner = computer
    else
      self.round_winner = 'tie'
    end
    score[round_winner] += 1
  end

  def reset_score
    score.each { |player, _| score[player] = 0 }
  end

  def endgame_winner?
    score.values.include?(FINAL_SCORE)
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
    if self.round_winner == 'tie'
      puts "It was a tie!"
    else
      puts "#{round_winner.name} won the round!"
    end
  end

  def display_endgame_winner
    if score[human] == score[computer]
      puts "At this point the score results in a tie!"
    else
      puts "#{round_winner} win's the entire game!"
    end
  end

  def play
    system 'clear'
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_moves
      update_score
      display_winner
      endgame_winner? ? display_endgame_winner : next
      play_again? ? reset_score : break
    end

    display_goodbye_message
  end
end

class Move < RPSGame
  attr_accessor :move, :name, :human

  @@history = {}

  WINS = { 'rock' => ['scissors', 'lizard'],
           'paper' => ['rock', 'spock'],
           'scissors' => ['paper', 'lizard'],
           'spock' => ['rock', 'scissors'],
           'lizard' => ['paper', 'spock'] }

  LOSES = { 'rock' => ['paper', 'spock'],
            'paper' => ['scissors', 'lizard'],
            'scissors' => ['rock', 'spock'],
            'spock' => ['paper', 'lizard'],
            'lizard' => ['scissors', 'rock'] }

  def initialize(value, user)
    convert_input(value) # @move setter method
    init_move_history(user)
    update_history(user)
  end

  def init_move_history(user)
    if Move.history.keys.none? { |player| player == user }
      Move.history[user] = []
    end
  end

  def self.history
    @@history
  end

  def update_history(user)
    Move.history[user] << self.move
  end

  def >(other_move)
    WINS[self.move].include?(other_move.to_s)
  end

  def <(other_move)
    WINS[other_move.to_s].include?(self.move)
  end

  def beats?(other_move)
    return true if WINS[self.move].include?(other_move.to_s)
    return false if WINS[other_move.to_s].include?(self.move)
    nil
  end

  def to_s
    @move
  end

  def str_to_move(value)
    WINS.keys.each do |m|
      @move = m if m.start_with?(value)
    end
  end

  def num_to_move(value)
    WINS.keys.each_with_index do |m, idx|
      @move = m if (idx + 1).to_s == value
    end
  end

  def convert_input(value)
    if value == value.to_i.to_s
      num_to_move(value)
    else
      str_to_move(value)
    end
  end
end

RPSGame.new.play

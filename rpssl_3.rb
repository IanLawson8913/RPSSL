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
      puts "Please choose:"
      puts ""
      puts "1) rock,     2) paper"
      puts "3) scissors  4) spock"
      puts "5) lizard    6) display move history"
      puts ""
      choice = gets.chomp
      if chose_display_history?(choice)
        display_move_history # display history
        next
      elsif valid_choice?(choice)
        system 'clear'
        break
      end
      puts "Sorry, invalid choice."
    end
    move = Move.new(choice, name)
  end

  def valid_choice?(choice)
    Move::WINS.keys.any? { |key| key.start_with?(choice) } ||
      (1..6).to_a.include?(choice.to_i)
  end

  def chose_display_history?(choice)
    choice == '6' || 'display move history'.start_with?(choice)
  end

  def display_move_history
    system 'clear'
    Move.history.keys.each do |player|
      puts "#{player}: " + Move.history[player].last(10).join(', ')
      puts ''
    end
  end
end

class Computer < Player
  attr_accessor :choices

  BASE_CHOICES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize
    @choices = BASE_CHOICES
  end

  def choose
    move = Move.new(choices.sample, name)
  end
end

# I pick rock every time... :/
class Ricky < Computer
  def initialize
    @name = 'Ricky'
    @choices = BASE_CHOICES[0]
  end
end

# I like lizards so I choose lizard %75 of the time
class Bill < Computer
  LIZARD_IDX = 4

  def initialize
    @name = 'Bill'
    @choices = BASE_CHOICES + [BASE_CHOICES][3] * 16
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
    update_choices if round > 0
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
    @computer = Spike.new # [Ricky.new, Bill.new, Spike.new].sample
    @score = { human => 0, computer => 0 }
    @round_winner = nil
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
    puts computer.move.to_s
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
      puts ''
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
      display_winner
      update_score
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
    convert_input(value) # @move setter meothod
    init_move_history(user)
    update_history(user)
  end

  def init_move_history(user)
    return unless Move.history.keys.none? { |player| player == user }
    Move.history[user] = []
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

  def to_s
    @move
  end

  def str_to_move(value)
    WINS.keys.each do |m, idx|
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

# score
# first player to win 10 wins game
# -- loop main game until score of human or comp == 10
# -- output winner

# is score a new class or a new state of an existing class?

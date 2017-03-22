class Move
  VALUES = ['rock', 'paper', 'scissors', 'spock', 'lizard']

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
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (spock? && (other_move.rock? || other_move.scissors?)) ||
      (lizard? && (other_move.paper? || other_move.spock?))
  end

  def <(other_move)
    (rock? && (other_move.spock? || other_move.paper?)) ||
      (paper? && (other_move.scissors? || other_move.lizard?)) ||
      (scissors? && (other_move.spock? || other_move.rock?)) ||
      (spock? && (other_move.paper? || other_move.lizard?)) ||
      (lizard? && (other_move.scissors? || other_move.rock?))
  end

  def to_s
    @value
  end
end

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
  def set_name
    self.name = ['Ricky', 'Spike', 'Lucy', 'Bill'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  FINAL_SCORE = 2

  attr_accessor :human, :computer, :score, :round_winner

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = { human => 0, computer => 0 }
    @round_winner = nil
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

  def update_score
    if human.move > computer.move
      self.round_winner = human
      score[human] += 1
    elsif human.move < computer.move
      self.round_winner = computer
      score[computer] += 1
    end
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

  def endgame_winner?
    score.values.include?(FINAL_SCORE) # too much chaining?
  end

  def reset_score
    self.score[human], self.score[computer] = 0, 0
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

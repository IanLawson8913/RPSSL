module Throwable
  def throw
    "The #{name} flies through the air..."
  end
end

class Toy                         # Superclass to HumanToy and DogToy
  @@total_toys = 0                # Class variabe

  def initialize(c)               # Constructor
    @color = c                    # Instance Variable
    @@total_toys += 1
  end

  def self.total_toys             # Class method 
    @@total_toys
  end

  def total_toys                  # Class method 
    @@total_toys
  end
end

class HumanToy < Toy              # Subclass to Toy

end

class DogToy < Toy
  def initialize(c, h)
    super(c)
    @hardness = 2
  end

  def some_method
    "I'm initialized in the DogToy Class!"
  end
end

class Ball < DogToy
  attr_accessor :name

  def initialize(c, h, name)
    super(c, h)
    @name = name
  end

  include Throwable

  def other_method
    "I'm initialized in the Ball Class!"
  end
end

class Plush < DogToy

end

kong = Ball.new('red', 10, 'Kong')
p kong
p kong.throw
p kong.total_toys
p kong.some_method

frisbee = DogToy.new('green', 2)
frisbee.other_method
# Constructors perform 3 jobs: allocate space, assign instance variables, and return the instance
# #initialize is an instance method used to assign instance variables
# #new is a class method and a constructor

# Class variable scope
# -- can be accessed from within an instance method defined in...

# Module
# -- A module that is inluded in a class definition shares the scope as if it were an instance 
# -- -- method within that class

# Instance Variable scope
# -- can be accessed within the class using the @ operator
# -- can be accessed outside of the class: use getter methods / setter methods


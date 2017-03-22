# Classes are used to create new objects
# When def a class
# -- states: track attributes for individual objects
# -- behaviors: what objects are capable of doing

# if we wanted to create two GoodDog objects: Fido and Sparky
# -- they could both contain different information such as weight, name etc...
# -- we could use isntance variables to track this information
# -- instance variables are scoped at the object (or instance) level
# -- -- and are how objects keep track of their states

# Fido and Sparky are two objects (or instances) of class GoodDog and 
# contain identical behaviors
# -- both should be able to bark, run, fetch
# -- -- these behaviors as instance methods in a class
# -- -- instance methods defined in a class are available to objects of that class

# state: instance variables
# behavior: instance methods

-- Initializing a New Object --

# good_dog.rb

class GoodDog
  def initialize
    puts "This object was initialized!"
  end
end

sparky = GoodDog.new # => "This object was initialized!"


# The initialize method gets called every time you create a new object

# calling the new class method eventually leads us to the initialize instance method
# more later on differences between instance and class methods

# instantiating a new GoodDog object triggered the initialize method and resulted
# in the string being output

# in this case initialize is called a:
Constructor: because it is triggerd whenever we create a new object


-- Instance Variables --

# good_dog.rb

class GoodDog
  def initialize(name)
    @name = name
  end
end

Instance_variable: A variable that exists as long as the object instance exists and
is one of the ways we tie data to objects

It doesnt die after the initialize method is run, it lives on to be referenced
until the object instance is destroyed

# You can pass arguments into the initialize method through the new method
# Let's create an object using the GoodDog class:

spark = GoodDog.new("Sparky")

# The string "Sparky" is passed from the #new method through to the #initialize method
# and is assigned to the local variable #name. Within the constructor (#initialize)
# we then set the instance variable @name to name which results in assigning the string
# "Sparky" to the @name instance variable

# Instance variables are responsible for keeping track of information about the state
# of an object

# Each time you create a new instance object of the same class, the state can change
# Every object's state is unique and instance variables are how you keep track of that

-- Instance Methods --

# At this point GoodDog class can't do anything; let's add some behaviors

class GoodDog
  def initialize(name)
    @name = name
  end

  def speak
    "Arf!"
  end
end

sparky = GoodDog.new("Sparky")
puts sparky.speak # => Arf!

# workes with another GoodDog object too:

fido = GoodDog.new("Fido")
puts fido.speak             # => Arf!

# updated instance method 

def speak
  "#{@name} says arf!"
end

puts sparky.speak           # => "Sparky says arf!"
puts fido.speak             # => "Fido says arf!"


-- Accessor Methods --

puts sparky.name

``
NoMethodError: undefined method `name' for #<GoodDog:0x007f91821239d0 @name="Sparky">   `

# if we want to access the object's name which is stored in the @name instance variable
# we have to create a method that will return the name

# good_dog.rb

class GoodDog
  def initialize(name)
    @name = name
  end

  def get_name    # getter method
    @name
  end

  def speak
    "#{@name} says arf!"
  end
end

sparky = GoodDog.new("Sparky")
puts sparky.speak
puts sparky.get_name # => Sparky

---

# good_dog.rb

class GoodDog
  def initialize(name)
    @name = name
  end

  def name           # renamed
    @name
  end

  def name=(name)    # renamed
    @name = name
  end

  def speak
    "#{@name} says arf!"
  end
end

sparky = GoodDog.new("Sparky")
puts sparky.speak
puts sparky.name # => Sparky
sparky.name = "Spartacus"   # setter method
puts sparky.get_name            # => Spartacus

# -- Syntatical Sugar -- #
# Ruby understands this "set_name=(name)" as a setter method and allows:
# sparky.set_name = "Spartacus" instead of sparky.set_name=("Spartacus")

# Rubyist want to name the getter and setter nmethods using the same name as the instance
# variable they are exposing and setting

--- attr_accesor / 

attr_reader (for just getter)
attr_writer (for just setter)

attr_accessor :name, :height, :weight (for multiple states)

# attr_accesor method helps save space:

# good_dog.rb

class GoodDog
  attr_accesor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} says arf!"
  end
end

--- 

# getter and setter methods can also be used from within the class

# instead of:

def speak
  "#{@name} says arf!"
end

# do this:

def speak
  "#{name} says arf!"
end

# it's better practice to reference the getter method instead of the instance variable directly

def ssn
  # converts '123-45-6789' to 'xxx-xx-6789'
  'xxx-xx-' + @ssn.split('-').last
end

# we also want to do this with calling the setter method

-- Calling Methods with self --

if we want to change several states at once

# good_dog.rb

class GoodDog

  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def speak
    "#{self.name} says arf!"
  end

  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end

  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end
end

sparky = GoodDog.new('Sparky', '12 inches', '10 lbs')
puts sparky.info # => Sparky weighs 10 lbs and is 12 inches tall.

sparky.change_info('Spartacus', '24 inches', '45 lbs')
puts sparky.info      # => Spartacus weighs 45 lbs and is 24 inches tall.


# Create a class called MyCar

class MyCar
  
  attr_accessor :year, :color, :model

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
  end
end


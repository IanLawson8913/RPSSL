# Object Oriented Programming OOP

# A programming paradigm created to deal with the growing complexity of
# large software systemes.

# Large programs were difficult to maintain and small changes in programs
# could cause a ripple effect throught the entire program due to
# it's dependencies


TERMS

Encapsulation: hiding pieces of functionality and making it unavailable
to the rest of the code.

-- form of data protection so that data cannot be changed without obvious
   intention
-- it is what defines the boundaries in your application and allows your 
   code to achieve new levels of complexity.
   # ruby does this by creating objects and exposing interfaces (ie. methods)
   # to interact with with those objects
-- allows programmers to think on another level of abstraction since 
   objects are represented as real-world nouns

Polymorphism: ability of data to be represented as many different types.
# can use pre-written code for new purposes

Inheritance: idea used in Ruby where a class inherits the behaviours of
another class (call the superclass)

# Ruby allows programmers to define basic classes with large reusibliliy
# and smaller subclasses for more specific behaviors

Module: similiar to classes since they contain shared behavior but you
cannot create an object with a module. A module must be mixed in with a class
using the reserved word include. This is called a Mixin:
# after mixing in a module the behaviors delcared in that module are available
# to the class and objects


Objects: Objects are create from classes. Classes are like molds and objects
are what is created by the mold. 
# individual objects will contain different information from other objects,
# yet they can be instances of the same class

"word".class => String
"other words".class => String

These two strings are different objects from the same class. They are instanciated (v.)
from the class String / They are instances (n.) of the class String


-- CLASSES DEFINE OBJECTS --

# Ruby defines the attributes and behaviors of its objects in classes

Classes are like basic outlines of what an object should be made of and
what it should be able to do.

To define a class:

# use CamelCase naming
# Ruby file names shoudl be in snake_case and reflect the class name

# good_dog.rb

class GoodDog
end

sparky = GoodDog.new

# we crated an instance of our GoodDog class and stored it in the the
# variable sparky. We now have an object. Sparky is an object or
# an instance class of GoodDog.

Instanciation: entire workflow of creating a new object or instance from
a class. We instanciated an object called sparky from the class GoodDog


-- Modules --

Module: a collection of behaviors that is usable in other classes via mixins:
A module is "mixed in" to a class using the include reserved word

If we wanted our GoodDog class to have a speak method but we have other classes
that we want to use a speak method with too :

``

# good_dog.rb

module Speak
  def speak(sound)
    puts "#{sound}"
  end
end

class GoodDog
  include Speak         # mixin
end

class HumanBeing
  include Speak         # mixin
end

sparky = GoodDog.new
sparky.speak("Arf!")    # => Arf!
bob = HumanBeing.new
bob.speak("Hello!")     # => Hello!

``

-- Method Lookup --

# When you call a method how does Ruby know where to look for that method?

Ruby as a destinct lookup path that it follows each time a method is called

You can use "#ancestors" method on any class to find out the lookup chain

``

puts "---GoodDog ancestors---"
puts GoodDog.ancestors
puts ''
puts "---HumanBeing ancestors---"
puts HumanBeing.ancestors

```
---GoodDog ancestors---
GoodDog
Speak
Object
Kernel
BasicObject

---HumanBeing ancestors---
HumanBeing
Speak
Object
Kernel
BasicObject

```
The Speak module is placed in between our custom class and the Object class that 
comes with Ruby

This means that since the speak method is not defined in the GoodDog class,
the next place it looks is in the Speak module. 

This continues in an ordered,
linear fashion until the method is either found or there are no more places to look

-- Exercises --

How do we create an object in Ruby? Give an example of the creation of an object.

# my_pets.rb

class Mammal
end

lisbeth = Mammal.new

---

What is a module? What is its purpose? How do we use them with our classes? 

  A module is a collection of behaviors that is usable in other classes. 
  1. Modules can give different objects a shared behavior (methods)
  2. Name spacing
  We can use them with our classes by mixing them in using mixins / include keyword

Create a module for the class you created in exercise 1 and include it properly.

# my_pets.rb

module BegForFood
  def beg_for_food(food)
    puts "I want #{food}!"
  end
end

class Mammal
  include BegForFood
end

lisbeth = Mammal.new
lisbeth.beg_for_food("chicken wings")
class Animal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Cat < Animal
  def speak
    "Mrow."
  end
end

class Dog < Animal
  def speak
    "bark!"
  end

  def fetch
    'fetching!'
  end

  def swim
    'swimming!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

# teddy = Dog.new
# puts teddy.speak           # => "bark!"
# puts teddy.swim    

# spike = Bulldog.new
# puts spike.speak
# puts spike.swim

puts Bulldog.ancestors
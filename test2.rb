# class Student
#   def initialize(n, g)
#     @name = n
#     @grade = g
#   end

#   def better_grade_than?(student)
#     grade > student.grade
#   end 

#   protected

#   attr_reader :grade
  
# end

# ian = Student.new('Ian', 89)

# bob = Student.new('Bob', 67)

# puts ian.better_grade_than?(bob)

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def to_s
    name
  end

  private

  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
p bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name
p bob.last_name

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p "The person's name is: #{bob}"


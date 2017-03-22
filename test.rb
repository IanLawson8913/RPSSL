module Raceable
  def race
    "I'm racing...Vroom vroooom :p"
  end
end

class Vehicle
  @@number_of_vehicles = 0

  attr_accessor :color
  attr_reader :year, :model

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
    @on = true
    @@number_of_vehicles += 1
  end

  def speed_up(mph)
    @speed += mph if @on
  end

  def brake(mph)
    @speed -= mph
    @speed = 0 if @speed < 0
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def shut_off
    @on = false
  end

  def spary_paint(color)
    @color = color
  end

  def to_s
    "You are driving a #{self.color} #{self.year} #{self.model}!"
  end

  def self.total_number_of_vehicles
    puts "This program has created #{@@number_of_vehicles} vehicles."
  end

  def car_age
    "This #{self.model} is #{calculate_age} years old."
  end

  private

  def calculate_age
    Time.now.year - year
  end
end

class MyCar < Vehicle 
  AVG_MPG = 25

  include Raceable
end

class MyTruck < Vehicle
  AVG_MPG = 14
end

accord = MyCar.new(1999, 'sivler', 'honda')

f_250 = MyTruck.new(2001, 'black', 'ford')

p accord.car_age
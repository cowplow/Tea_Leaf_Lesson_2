#my_car

module FourWheelDrivable

  def four_wheel_drive
    puts "Now in 4 wheel drive mode!"
  end
end


class Vehicle
  attr_accessor :color
  attr_reader :model, :year

  @@vehicles = 0

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @current_speed = 0
    @@vehicles += 1
  end

  def speed_up(number)
    @current_speed += number
    puts "You push the gas and accelerate #{number} mph."
  end

  def brake(number)
    @current_speed -= number
    puts "You push the break and decelearte #{number} mph."
  end

  def current_speed
    puts "You are now going #{@current_speed} mph"
  end

  def shut_down
    puts "Lets park this bad boy!"
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles/gallons.to_f} miles per gallon"
  end

  def self.number_of_vehicles
    p @@vehicles
  end

  def get_age
    puts "Your #{self.model} is #{vehicle_age} years old"
  end

  private

  def vehicle_age
    age = Time.now.year - self.year
  end
end

  class MyCar < Vehicle
    NUMBER_OF_DOORS = 4

    def to_s
      "My car is a #{self.color}, #{self.year}, #{self.model}"
    end
  end

  class MyTruck < Vehicle
    include FourWheelDrivable

    NUMBER_OF_DOORS = 2

    def to_s
      "My truck is a #{self.color}, #{self.year}, #{self.model}"
    end
  end

  lumina = MyCar.new(1997, 'chevy lumina', 'white')
  lumina.speed_up(20)
  lumina.current_speed
  lumina.speed_up(20)
  lumina.current_speed
  lumina.brake(20)
  lumina.current_speed
  lumina.brake(20)
  lumina.current_speed
  lumina.shut_down
  MyCar.gas_mileage(13, 351)
  lumina.spray_paint("red")
  puts lumina
  puts MyCar.ancestors
  puts MyTruck.ancestors
  puts Vehicle.ancestors

  truck = MyTruck.new(2013, "chevy tahoe", "purple")

  truck.four_wheel_drive
  truck.get_age

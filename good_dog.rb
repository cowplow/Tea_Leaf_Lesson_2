class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age = a * DOG_YEARS
  end

  private

  def human_years
    self.age / DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
sparky.human_years
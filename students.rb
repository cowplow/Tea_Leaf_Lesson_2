#students.rb

class Student
  attr_accessor :name, :grade

  def better_grade_than?(student)
    @grade > student.grade
  end

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new("Joe", 95)
bob = Student.new("Bob", 90)

puts "Well done!" if joe.better_grade_than?(bob)

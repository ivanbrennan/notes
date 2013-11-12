# Attributes are properties we give our objects.
 
# Just like every person can have a name,
# a height, an address, etc, we can model
# characteristics of an object by giving it
# attributes.
 
# Every attribute is stored in an instance variable.
 
# An object's instance variables are its attributes,
# the things that distinguish it from other objects
# of the same class.
 
# reload (exit/restart) for all your examples.
 
class Person
 
  def name=(str)
    @name = str
  end
 
end
 
# Attributes are just implemented via methods in ruby.
# The name= method accepts one argument, a string,
# that is the name of the individual.
 
# Each instance or individual person gets their own
# name and their own copy of the @name variable.
 
# Try in console (grab the Person class from above).
 
class Person
 
  def name=(str)
    @name = str
  end
 
end
 
puts avi = Person.new
#=> #<Person:0x007fb4dc81add8>
avi.name = "Avi Flombaum"
puts avi
#=> #<Person:0x007fb4dc81add8 @name="Avi Flombaum">
 
# Notice how ruby outputs the person instance,
# referenced by the local variable avi.
# It looks like a standard object.
 
# We call the name= method passing in the name,
# and then reputs the object.
 
# Notice that in the object outputs the Person
# instance, represented with the weird #<Object>
# syntax, actually has a property within it
# @name.
 
# But try to read that property, try to get
# the name out.
 
class Person
 
  def name=(str)
    @name = str
  end
 
end
 
avi.name
#=> NoMethodError: undefined method `name' for #<Person:0x007fb4dc81add8 @name="Avi Flombaum">
 
# We have to build a method that will make the value
# of @name accessible to the rest of our code,
# to the public, so to speak.
 
# Let's define a reader for @name
 
class Person
 
  def name=(str)
    @name = str
  end
 
  def name
    @name
  end
 
end
 
# Why can't we just read the
# value from @name? We want our variables to belong
# to only the object, not the rest of our code.
 
# There are a few reasons, most of them have to do
# with encapsulation and SOLID Object Design
# http://en.wikipedia.org/wiki/Solid_(object-oriented_design)
 
# Take the following for example.
# http://apidock.com/ruby/Object/instance_variable_get
avi.instance_variable_get(:@name)
#=> "Avi Flombaum"
avi.name
#=> "Avi Flombaum"
 
# / Syntactic Vinegar /
# I believe that instance_variable_get is an
# unruby-esque method name in that in contains
# a verb and additionally puts the verb
# dangling at the end, if anything, it should
# read get_instance_variable. It's weird name
# should remind us, DON'T DO THIS.
 
# Seems fine, right?
# But then we decide that people need a first name
# and last name.
 
class Person
 
  def first_name=(str)
    @first_name = str
  end
 
  def last_name=(str)
    @last_name = str
  end
 
  def name
    "#{@first_name} #{@last_name}"
  end
 
end
 
# Because we depended on a literal or concrete
# variable, our code is broken
 
avi = Person.new
avi.first_name, avi.last_name = "Avi", "Flombaum"
 
avi.name #=> "Avi Flombaum"
avi.instance_variable_get(:@name) #=> nil
 
# The method, name, is an abstraction of a value
# whereas the instance variable @name is a literal
# value. The literal value reference, the variable
# @name, may change as our application grows.
 
# But the interface, how our application uses
# that value, that can remain constant, a method
# called name.
 
# So we store an objects data in instance variables
# but we reveal those values to our code
# via methods. Those methods are called readers and
# writers, or setters and getters.
 
# They generally come in pairs, but notice that
# the name method above is a reader to a composite
# value made up of two instance variables. It
# also does not have a corresponding writer
# name=.
 
# We should talk a bit about this notion of a public
# interface vs private interface.
 
# read this:
# http://zetcode.com/lang/rubytutorial/oop/
# http://zetcode.com/lang/rubytutorial/oop2/
 
# Macros: attr_reader, attr_writer, attr_accessor
 
# Macros are code that writes code for you.
 
# All this manual definition of readers/writers
# is annoying given the strong convention
# of a reader reading from an instance variable
# of the same of the method, and the writer, writing
# to that instance variable named after the method,
# we have macros in our classes to automatically
# define those methods
 
# attr_reader will define a reader method.
 
# reload (exit/restart) for all your examples.
 
class Person
  attr_reader :first_name, :last_name
 
  def name=(str)
    @first_name, @last_name = str.split
  end
end
 
avi = Person.new
avi.name = "Avi Flombaum"
avi.name #=> NoMethodError
avi.first_name #=> "Avi"
avi.last_name #=> "Flombaum"
 
# attr_writer will define a writer
 
class Person
  attr_writer :name
 
  def first_name
    @name.split.first
  end
 
  def last_name
    @name.split.last
  end
end
 
avi.name = "Avi Flombaum"
avi.first_name #=> "Avi"
avi.last_name #=> "Flombaum"
avi.name #=> NoMethodError
 
# Finally, attr_accessor gives you both
 
class Person
  attr_accessor :name
end
 
avi = Person.new
avi.name = "Avi Flomabaum"
avi.name #=> "Avi Flombaum"
 
# Arbitrary Instance Variables
 
# It is possible to have instance variables created
# in sort of weird methods.
 
class Jukebox
 
  def exit
    @power = false
    puts "Goodbye"
  end
 
  def on?
    @power
  end
 
end
 
# The exit method is acting like a writer
# but it doesn't end with =
# and it does more than just write a value.
# But that is a fine usage. It'd be correct
# to describe @power not as an attribute, but rather
# as a state, or a flag, or a switch.
 
# Similarly, on? isn't your standard reader.
# It reads from a different variable name
# and ends in a question mark. Still valid.

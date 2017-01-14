# Humanized Classes
This is my first shot at a DSL. Using rspec inspired syntax, this DSL allows you to create very basic classes in a more human friendly way.

```ruby
require 'humanized_classes'

a :Person do
  will_be :initialized_with, :name, :age, :height, :hidden
  the_instance_variable  :name,         :will_be_readable
  the_instance_variable  :hidden,       :will_be_writable
  the_instance_variables :age, :height, :will_be_accessible
  the_instance_variable  :hidden,       :will_be_set_to, 42
  and_thats_it
end

person = Person.new(:Tom, 21, 170)
 => #<Person:0x000000012accf8 @name=:Tom, @age=21, @height=170, @hidden=42>
```

If you'd like to see the code generated just change the last line to...
```ruby
and_thats_it "now_show_me"
```

The following is printed for the above code...

```ruby
class Person
  def initialize(name, age, height)
    @name = name
    @age = age
    @height = height
    @hidden = 42
  end
end

class Person
  attr_reader :name
end

class Person
  attr_writer :hidden
end

class Person
  attr_accessor :age
end

class Person
  attr_accessor :height
end

```


# Truthiness

- [Booleans](#booleans)
- [Truthiness and Falsiness](#truthiness-and-falsiness)
- [nil](#nil)
- [Truthiness in the Wild](#truthiness-in-the-wild)

## Booleans

Boolean data types are those that are represented by the objects `true` or `false`. These objects are separate from strings, and actually represent classes of their own.

```ruby
true.class    # => TrueClass
false.class   # => FalseClass
```

`true` and `false` objects are the result of evaluating Boolean expressions. Boolean expressions consist of statements that use relational operators - such as comparison (`<`, `>`, `<=`, `>=`) and equality (`==`) - or logical operators (such as and `&&`, or `||`, and not `!`).

```ruby
2 < 4           # => true
"hi" == "hi"    # => true
1 > 2           # => false
'a' == 'z'      # => false
```

They are also often the result of methods that determine something about the calling object. These methods often end in a `?` by convention.

```ruby
"hello".include?("h")   # => true
2.odd?                  # => false
[1, 2, 3, 4].any? { |num| num.even? }
# => true
```

The Boolean objects are the only true representations of "true" and "false".

## Truthiness and Falsiness

Ruby evaluates more than just expressions and methods for `true` and `false`. In fact, any object in Ruby can be evaluated in this way. Depending on how an object is evaluated, that object can be considered to be either **truthy** or **falsey**.

In Ruby, **all objects are considered to be truthy** with only two exceptions, `false` and `nil`.

We can check to see how certain objects are evaluated by using them in conditional expressions.

```ruby
puts "true" if 5          # => "true"
puts "true" if 0          # => "true
puts "true" if "hello"    # => "true"
puts "true" if nil        # no output
puts "true" if false      # no output

puts "true" if n = 3      # => "true" (because assignment always returns the object it assigns)

a = [1, 2, 3]
puts "true" if a          # => "true"

def some_method
  "truthy object"
end

puts "true" if some_method
# => "true" (some_method returns a truthy value)

def another_method
  nil
end

puts "true" if another_method
# => no output, because `another_method` returns a falsey value
```

Note that even the integer `0` is a truthy object in Ruby.

Just because an object _evaluates_ to `true`, does not necessarily make it the _same_ as `true` (hence, calling it "truthy")

```ruby
puts "true" if 5    # => true
5 == true           # => false
```

## nil

`nil` in Ruby is a particular kind of object used to represent the absence of any kind of value. It basically means, "nothing". It is the only object in Ruby that will evaluate to `false` (other than the Boolean `false`).

We can expect to see `nil` in situations where something is _output_, but nothing is _returned_, such as when we call the method `puts`.

```ruby
puts "hi there!"
# => outputs "hi there!"
# => returns `nil`
```

`nil` is returned when a conditional is evaluated, and the code inside is not run.

```ruby
if 2 > 3
  "bad math"
end

# nothing is output, as the expression evaluates to false
# the conditional as a whole returns `nil`, as no code is run
```

When trying to reference elements that lie "outside" the boundaries of a collection, `nil` is returned.

```ruby
array = [1, 2, 3, 4]
array[4]                # => nil
array[-5]               # => nil

string = ''
string[0]               # => nil

hash = { a: 1, b: 2}
hash[:c]                # => nil
```

Like truthy values, `nil` is not equivalent to `false` just because it is evaluated that way.

```ruby
puts "true" if nil    # => no output, nil evaluates to false
nil == false          # => false
```

## Truthiness in the wild

The truthiness of Ruby objects has consequences we have to be aware of when writing code.

Assignment is always truthy (unless you are assigning `false` or `nil`), because it always returns the object that is assigned. Because the assignment operator (`=`) looks so much like the equality operator (`==`), this can cause bugs when used in conditional statements.

```ruby
num = 1

if num = 1          # always evaluates to true
  "I will always run."
else
  "I will never run."
end
# => "I will always run"

if num == 0         # sometimes evaluates to true
  "I will run if num is equal to 0"
else
  "I will run if num is not equal to 0"
end
# => "I will run if num is not equal to 0
```

Some methods, such as `select`, `any?`, and `all?` are passed a block and evaluate the truthiness of that block's return value to perform some action.

`select`, for example, passes each element of it's calling collection to the block that gets passed to it. Then, it returns a new collection of those elements for which the block returned a truthy value. Therefore, if an expression that does not have the ability to evaluate to `false` or `nil` is the last line of the block, all items in the calling collection will be returned.

```ruby
[1, 2, 3, 4, 5, 6].select { |num| num % 2 }
# block returns either 0 or 1, depending on whether num is odd or even
# both 0 and 1 are truthy values
# therefore select selects all items in the calling collection
# => [1, 2, 3, 4, 5, 6]

[1, 2, 3, 4, 5, 6].select { |num| num % 2 == 0 }
# block returns either true or false, depending on whether num is odd or even
# select returns only those elements that return true when passed to the block
# => [2, 4, 6]
```

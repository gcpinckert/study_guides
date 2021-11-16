# Return Values

- [What is a Return Value?](#what-is-a-return-value)
- [Ruby's Implied Return](#implied-return)
- [Chaining Methods](#chaining-methods)
- [Methods as Arguments](#methods-as-arguments)
- [Output vs. Return](#output-vs-return)
- [Return Values with Blocks](#return-values-with-blocks)

## What is a return value?

A **return value** is the object that is _returned_ by a method or block in Ruby. You can cause a method to return any particular object by using the `return` keyword.

```ruby
def a_method
  return "I am a return value!"
end

a_method                    # => "I am a return value!"
```

In the code above, the `a_method` method returns the string object `"I am a return value!"`. Return values are not automatically output to the console, but you can pass them to other methods, or save them in variables.

```ruby
def a_method
  return "I am a return value!"
end

value = a_method
p value                   # => "I am a return value!" (output)
```

Above, we store the string `"I am a return value!"`, which is returned by `a_method` in the local variable `value`. Now we can access that object to pull it up, manipulate, and output it if we wish.

You can use the `return` keyword anywhere within the method, but note that any code that comes after it will never get run. This is because `return` causes the computer to exit the method and go back to the main function of the program.

```ruby
def a_method
  return "I am a return value!"
  p "I will never get run"
end

p a_method                  # => "I am a return value!"
```

Given the above method definition for `a_method`, we can see that any code below the `return` statement will never get run. When we invoke `a_method`, (and pass it to `p` in order to output the return value), the only output will be the line `"I am a return value!"`. Because we exit the method with the `return` statement, `"I will never get run"` is never output.

## Implied Return

Ruby has something known as an **implied return**. This means that a method or block will _always_ return the value that the last line evaluates to. Because of this, you only need a `return` statement should you need to exit the method prematurely.

```ruby
def a_method
  "I am a return value!"
end

p a_method                # => "I am a return value!"

def simple_math
  2 + 2
end

p simple_math             # => 4
```

## Chaining methods

Because methods in Ruby always return some value, you can chain methods together. Each subsequent value will be called by the object that was returned by the previous method.

```ruby
a = 'hello'
a.concat('!').upcase
# => returns "HELLO!"
# a.concat('!') => "hello!"
# .upcase => "HELLO!"
```

## Methods as arguments

Based along the same principles, you can also use methods as arguments. The object that will get passed as an argument will be the return value of the method used. Or, to be super specific, a copy of the reference to the object returned by the method.

```ruby
def add_two(x, y)
  x + y
end

def some_num
  (1..10).to_a.sample
end

p add_two(some_num, some_num)
# => returns 15 (or some other random number)
```

Above, we have two methods defined. The first one `add_two` adds two arguments together, and returns the sum. The second, `some_num` randomly selects a number between 1 and 10 and returns it.

Therefore, when we call `add_two` and pass it `some_num` and `some_num` as it's arguments, the computer will invoke `some_num` twice and pass in the return value of each invocation as the arguments for `add_two`.

Finally, the object returned by `add_two` (the sum) is passed to the `p` method and output to the console.

## Output vs Return

A return value is not the same thing as output. Output indicates that something is "output" to `STDOUT`. Usually, this means that it will print on the console or terminal. In Ruby, this is acheived by passing object to methods such as `puts`, `p`, or `print`.

Be careful, however, as these methods do not always return what they are outputting. `puts`, for example, returns `nil`. So if you end a method with `puts` you can see the return value of a particular statement, but you actually change the return value of the method (or block) as whole to `nil`.

```ruby
def a_method
  puts "I am just an object! I will not be returned!"
end

a_method 

# => outputs, "I am just an object! I will not be returned!
# => returns `nil`
```

## Return Values with Blocks

Blocks also have return values. These are not always used by the methods they get passed to, but sometimes they are.

Methods like `times` and `each` do not use the return value of the block. `times` will always return the integer that calls it (unless the loop is broken prematruely), and `each` will always return the collection that calls it.

```ruby
1.times { 2 + 2 }
# => returns '1'

[1].each { |num| num + 4 }
# => returns [1]
```

Other methods that takes blocks, however, _do_ use the return value of the block. So you must ensure that the return value of the block is appropriate for how it will be used by the method.

`map`, for example, uses the return value of the block that gets passed to it for [transformation](./working_with_collections.md#transformation). It will return a new array of elements, and each element will be the return value of the block for that iteration. Therefore, the last line of the block must evaluate to whatever you want the transformation to be.

```ruby
[1, 2, 3, 4].map { |num| puts num * 2 }
# => returns [nil, nil, nil, nil]

[1, 2, 3, 4].map { |num| num * 2 }
# => returns [2, 4, 6, 8]
```

`select` uses the return value of the block that gets passed to it for [selection](./working_with_collections.md#selection), selecting only those elements from the calling collection which return a truthy value. That means you must ensure the code within the block ends with a statement that has the ability to evaluate to `false` or `nil`. Otherwise, the whole calling collection will be selected.

```ruby
[1, 2, 3, 4].select { |num| num % 2 }
# => returns [1, 2, 3, 4]

[1, 2, 3, 4].select { |num| num % 2 == 0 }
# => returns [2, 4]
```

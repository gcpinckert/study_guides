# Variable Scope

- [Variables](#variables)
- [Scope](#scope)
  - [Global vs Local Scope](#global-vs-local-scope)
  - [Inner vs Outer Scope](#inner-vs-outer-scope)
- [Scopes with a Block](#scopes-with-a-block)
  - [Variable Shadowing](#variable-shadowing)
- [Scopes with Methods](#scopes-with-methods)

## Variables

**Variables** are basically storage containers for information as represented by Ruby objects (such as strings, integers, arrays, etc). Variables act like **pointers**, that is they contain references to the objects they point to in memory. Variables are assigned to objects using the assignment operator (`=`).

## Scope

**Scope** is the characteristic of a variable that defines where that variable can be accessed. It refers to which parts of the code consider the variable to be "defined"; that is, where the object the variable references can be pulled up and manipulated.

```ruby
def different_scope
  puts message
end

message = "I am a defined variable pointing to a string object"

# below, the variable message is within the current scope, and can be accessed
puts message
# => "I am a defined variable pointing to a string object

# local variables cannot be accessed from within methods, which have their own independent scope
different_scope
# => NameError (undefined local variable or method `message' for main:Object)
```

The scope of any given variable is defined by _where the variable is initialized_. Different scopes are defined by different kinds of code boundaries in Ruby.

### Global vs Local Scope

Variables with **global scope** are defined outside of any method definitions and can be accessed from anywhere in the program. In Ruby, global scope is limited to **constants** and **global variables**. Note that constants can be accessed even if they are initialized in inner scope (but this usually isn't done).

```ruby
MESSAGE = "I can be accessed anywhere"

def different_scope
  puts MESSAGE
end

puts MESSAGE    # => "I can be accessed anywhere"
different_scope # => "I can be accessed anywhere"
```

Variables with **local scope** are defined within a method or in the main function of the program, and they obey all scope boundaries. That is, the object they reference can only be accessed if that particular variable is _in scope_. Otherwise, the program will throw a NameError, and consider the variable undefined. If you wish certain methods to have access to variables not in their scope, you will have to pass those variables around as arguments.

```ruby
def different_scope(string)
  puts "This method accepts a local variable as an argument"
  puts string
end

message = "I am a local variable."

puts message  # => "I am a local variable."
puts different_scope(message)
# => "This method accepts a local variable as an argument."
# => "I am a local variable"
```

### Inner vs Outer Scope

In Ruby, inner and outer scope is defined by a **block**. A **block** is a piece of code surrounded by either curly braces `{}` or `do..end` that is passed to a method invocation as an argument.

Local variables defined in **outer scope** (i.e. outside the block) can be accessed from **inner scope** (i.e. inside the block). However, local variables defined in **inner scope** (inside the block) _cannot_ be accessed from **outer scope** (outside the block).

```ruby
x = "I am a local variable initialized in outer scope."

1.times do |n|  # method call with a block
  x = "So I can be accessed and re-assigned in inner scope."
  y = "I am a local variable initialized in inner scope."
end

puts x
# => "So I can be accessed and re-assigned in inner scope."
puts y
# => NameError (undefined local variable or method `y' for main:Object)
```

## Scopes with a Block

Note that a **block** is usually defined by curly braces `{}` or `do..end`, but not all code surrounded by `do...end` constitutes a block that creates a separate scope. Only blocks that are passed to a **method call** will create inner and outer scope.

```ruby
# block passed to a method call, creates separate scope
loop do
  a = "inner scope variable"
end

puts a # => NameError

# not a block, despite do...end, so no separate scope is created
i = 0
while i < 1 do
  b = "can be accessed in outer scope"
  i += 1
end

puts b # => "can be accessed in outer scope"
```

When a block _is_ passed to a method call, it creates an **inner scope** for local variables. A variable initialized within the block will have inner scope, while a variable initialized outside the block (within the main body of the program) will have outer scope.

Outer scope variables can be accessed from within inner scope. That is, any outer scope variable defined outside the block can be accessed, manipulated, changed, or re-assigned within the block ([Inner vs Outer Scope](#inner-vs-outer-scope)).

Inner scope variables cannot be accessed from outer scope. Trying to access the objects they reference outside the block will cause the program to throw a NameError ([Inner vs Outer Scope](#inner-vs-outer-scope)).

If you have two separate blocks (known as _peer blocks_) they will each define their own independent inner scopes. These scopes will not interact or interfere with each other in any way. Any variable initialized within the inner scope of one block will _not_ be accessible from the inner scope of the other block (nor the outer scope).

Should these blocks each contain a variable defined within inner scope, both of the same name, these would be separate variables that point to separate objects in memory.

```ruby
1.times do
  a = "local variable a"
  b = "local variable b"
  puts a.object_id
end

1.times do
  a = "local variable a"
  puts a.object_id
  puts b
end

# => 260
# => 280
# => NameError (`b` is out of scope)
# two separate variables initialized in two separate blocks result in
# two separate object id's, even though the objects are identical
```

Nested blocks create nested levels of inner and outer scope. The terminology in this case differs, instead of inner and outer, we say _first level_ scope, _second level_ scope, _third level_ scope, and so on. First level scope will refer to the outermost scope of the program, and progress on down. Variables initialized in first level scope will be accessible in all the remaining inner scopes. Variables initialized in second level scope will be accessible in higher level inner scopes, but not first level scopes. Variables initialized in third level scope will be accessible from higher level inner scopes, but not from second or first level scopes.

```ruby
a = "First level variable"

1.times do
  b = "Second level variable"

  1.times do
    c = "Third level variable"

    puts a                      # => "First level variable"
    puts b                      # => "Second level variable"
    puts c                      # => "Third level variable"
  end

  puts a                        # => "First level variable"
  puts b                        # => "Second level variable"
  puts c                        # => NameError (out of scope)
end

puts a                          # => "First level variable"
puts b                          # => NameError (out of scope)
puts c                          # => Name Error(out of scope)
```

### Variable Shadowing

**Variable shadowing** blocks inner scope from accessing a specific local variable in outer scope. It occurs when a block parameter takes the same name as an already initialized local variable in outer scope. Variable shadowing causes the code within the block to reference the object the block parameter points to, rather than the object referenced by the local variable in outer scope with the same name. Further, it makes it so you cannot change or re-assign that outer scope local variable.

```ruby
a = "Local variable in outer scope"

%w(each element is passed to the parameter per iteration).each do |a|
  puts a
end

# => 'each'
# => 'element'
# => 'is' ... etc

b = "Local variable in outer scope"

%w(elements to assign to parameter).each do |b|
  b = "Let's try to assign a new value"
end

puts b
# => "Local variable in outer scope"
```

Try to choose specific and descriptive variable names to avoid this issue.

## Scopes with Methods

A **method**'s scope is entirely independent and self contained. Any local variable accessed by a method must either be initialized within the method (in which case, that variable will not be accessible in the main scope of the program) or passed to the method as an argument.

```ruby
a = "local variable in main function of program"

def method
  puts a
end

method    # => NameError (method cannot access 'a')

# pass in the variable as an argument

b = "local variable"

def method(variable_to_pass_in)
  puts variable_to_pass_in
end

method(b)   # => "local variable"
```

Local variables that are passed in to methods as arguments cannot be altered from within the method (unless those variables happen to reference collection objects, whose elements can be changed to achieve mutation).

```ruby
a = 'local variable'

def change_method(variable)
  variable = 'reassigned in the method'
end

change_method(a)     # => returns 'reassigned in the method'
puts a               # => 'local variable'
```

Blocks within a method invocation will create an outer and inner scope within the method. These follow the normal rules of scoping as they would in the main function of the program.

```ruby
def method_containing_block
  a = "Outer scope within the method"

  1.times do
    b = "Inner scope within the method"
    puts a      # => "Outer scope within the method"
    puts b      # => "Inner scope within the method"
  end

  puts a        # => "Outer scope within the method."
  puts b        # => NameError (`b` is out of scope here)
end

puts a          # => NameError (`a` cannot be accessed outside the method)
puts b          # => NameError (`b` cannot be accessed outside the method)
```

# Ruby Collections

1. [What is a collection?](#what-is-a-collection?)
2. [Element Reference](#element-reference)
    - [String Element Reference](#string-element-reference)
    - [Array Element Reference](#array-element-reference)
    - [Hash Element Reference](#hash-element-reference)
    - [Element Reference Tricks](#element-reference-tricks)
3. [Conversion](#conversion)
4. [Element Assignment](#element-assignment)
    - see also: [Indexed Assignment](mutating_methods_object_passing.md#indexed-assignment)
5. [Iteration](#iteration)
    - [Basic Looping](#basic-looping)
    - [Iterating over Hashes](#iterating-over-hashes)
6. [Selection and Transformation](#selection-and-transformation)
    - [Selection](#selection)
    - [Transformation](#transformation)
    - [Extracting to Methods](#extracting-to-methods)
7. [Sorting](#sorting)
    - [Comparison](#comparison)
    - [Sorting Methods](collection_methods.md#sorting-methods)
8. [Nested Data Structures](#nested-data-structures)
    - [Referencing Collection Elements](#referencing-collection-elements)
    - [Updating Collection Elements](#updating-collection-elements)
    - [Variable Reference in Nested Collections](#variable-reference-in-nested-collections)
    - [Shallow Copy](#shallow-copy)
    - [Freezing Objects](#freezing-objects)

## What is a collection?

A collection is a Ruby object or data structure that is made up on individual elements. Collections include Strings, Arrays, and Hashes, among other things.

## Element Reference

**Element reference** refers to the way we can reference, and therefore manipulate, individual elements within a collection.

### String Element Reference

Each individual character in a string can be referenced using an _integer based index number_. The first character in a string is said to be at `index 0`. Each subsequent character has an index that is increased by `1`.

We can use the `String#[]` or `String#slice` methods to isolate individual elements, of groups of elements.

```ruby
string = '01234'
string[0]         # => '0'
string[1]         # => '1'
string[2]         # => '2' ... etc

s = 'Hello World'
s[0]              # => 'H'
s[2]              # => 'l'
s[-1]             # => 'd'
s[2, 3]           # => 'llo'; starts at index 2, returns 3 chars
s[2, 3][2]        # => 'o'; returns char at index 2 in substring returned by s[2, 3]
```

### Array Element Reference

Arrays also use an _integer based index number_ to reference each element within the collection. Similarly to strings, we can use `Array#[]` or `Array#slice` methods to access individual elements or sub-groups of elements.

```ruby
arr = %w(a b c d e f g)
arr[0]          # => 'a'
arr[1]          # => 'b'
arr [-1]        # => 'g'
arr[2, 3]       # => ['c', 'd', 'e']; starts at index 2, returns 3 elements
arr[2, 3][2]    # => 'e'; returns element at index 2 in subarray returned by arr[2, 3]
```

Note that the bracket notation above is equivalent to the `slice` method.

```ruby
arr = %w(a b c d e f g)
arr.slice(3, 1)  # => ['d']
arr.slice(3..3)  # => ['d']
arr.slice(3)     # => 'd'
```

### Hash Element Reference

Hashes are data structures that use _key-value pairs_ to order objects instead of an integer based index. Either the key or the value in a hash can be any type of Ruby object. Each key in a hash must be unique, but values can be duplicated.

We can access a particular value by using it's associated key with `Hash#[]`.

```ruby
hash = { one: 1, two: 2, three: 3 }
hash[:one]      # => 1
hash[:two]      # => 2

hsh = { 1 => 'one', 2 => 'two' }
hash[2][2]      # => 'o'; returns the character at index 2 in the string returned by hash[2]
```

Use the `Hash#keys` method to return an array containing all the keys in the calling hash. Use the `Hash#values` method to return an array containing all the values in the calling hash. Each individual key and value, then, can be accessed via it's index within the array.

```ruby
hash = { one: 'son', two: 'shoe', three: 'free' }
hash.keys     # => [:one, :two, :three]
hash.values   # => ['son', 'shoe', 'free']
```

### Element Reference Tricks

#### Out of Bounds

In both strings and arrays, if you try to reference and index that is _out of bounds_ (i.e. it is bigger or smaller than the collection object itself), it will return `nil`.

```ruby
string = "Hello"
string[5]       # => nil
string[-6]      # => nil

array = [1, 2, 3]
array[3]        # => nil
array[-4]       # => nil
```

When dealing with strings, this error is pretty obvious, since we know that each referenced element has to be some kind of character, which `nil` is not.

In arrays, however, `nil` is a valid value for an array element. So, it is impossible to tell if you are getting a `nil` result from being out of bounds or if you are simply retrieving `nil` as a valid array element. In this case, it's better to use `Array#fetch` which will through an `IndexError` if the index is out of bounds instead of just returning `nil`.

```ruby
arr = ["one", :two, 3, nil]
arr[4]          # => nil (out of bounds index provided)
arr[3]          # => nil (value at array index 3)

arr.fetch(3)    # => nil
arr.fetch(4)    # => IndexError
```

#### Negative Indices

Elements in both strings and arrays can be referenced using negative index numbers as well. When using negative index numbers, `-1` starts at the last element in the collection and counts backwards.

```ruby
array = [0, 1, 2, 3, 4]
array[-1]       # => 4
array[-2]       # => 3
array[2..-1]    # => [2, 3, 4]
```

#### Invalid Hash Keys

If the key used with `Hash#[]` does not exist in the calling hash, the method will return `nil`. Like with arrays, `nil` is a valid hash value, so there is no way to tell if you are accessing a non-existant hash key or returning a valid `nil` value. Use `Hash#fetch` to distinguish between these results, which will throw a `KeyError` if the given key is not found.

```ruby
hsh = {one: 'son', two: 'shoe', infinity: nil }
hsh[:one]       # => 'son'
hsh[:three]     # => nil (no such key)
hsh[:infinity]  # => nil (valid hsh value)

hsh.fetch(:infinity)  # => nil
hsh.fetch(:three)     # => KeyError
```

## Conversion

Strings and arrays are structured similarly (zero-based index) so it's easy to convert between the two.

- `String#chars` returns an array in which each element in a single character from the calling string.
- `Array#join` returns a string with the elements of the array joined together. You can pass it a _delimiter_ which will be input between each element in the calling array once it is converted to a string.
- `String#split` is a good choice when you want to convert a string into an array of individual sub-strings rather than single characters. You pass it the character(s) to split along as an argument, and this will not be included in the resulting sub-string elements. The default is a `' '`.

You can also convert between hashes and arrays, but you need to be aware of the structural necessities to do so.

- `Hash#to_a` returns a two-dimensional array in which each sub-array has two elements; each key-value pair from the calling hash.
- `Array#to_h` is usually invoked by a two-dimensional array in which each sub-array has two elements, and returns a hash in which each sub-array's elements are the collection's key-value pairs. If you need to convert an array of a different data structure to a hash, you can pass this method a block which returns a two-element array, and these elements will form the key-value pairs in the new hash.

## Element Assignment

Change individual element values within a collection by using a [setter method](./variables_pointers.md#setter-methods), also known as an "element assigner method". Element assignment may _look_ like it is using the assignment operator (`=`), but in fact this is not the case. Element assignment methods are discreet methods defined for each object type, such as `String#[]=`, `Array#[]`, and `Hash#[]=`. The way we can disguise them as actual assignment statements is part of Ruby's **syntactical sugar**.

Note that this is _a destructive action_ that permanently modifies the collection (see [Indexed Assignment](mutating_methods_object_passing.md#indexed-assignment)).

- To change the value of a specific character within a string, use `String#[]` combined with the assignment operator.

  ```ruby
  string = "Fix my tupo!"
  string[8] = 'y'
  puts string       # => "Fix my typo!"
  ```

- Use `Array#[]` to change the value of a specific element within the array. You can also use any of the abbreviated assignment operators (syntactical sugar) to manipulate certain types of data.

  ```ruby
  array = [1, 2, 4, 4, 5, 6]
  array[2] -= 1
  p array           # => [1, 2, 3, 4, 5, 6]
  ```

- Use `Hash#[]` with the desired key to change a corresponding value.

  ```ruby
  hsh = { orchid: 'plant', rosemary: 'plant' }
  hsh[:orchid] = 'flower'
  hsh[:rosemary] = 'herb'
  p hsh             # => {orchid: 'flower', rosemary: 'herb' }
  ```

## Iteration

### Basic Looping

You can use a basic loop (with `Kernal#loop`) to iterate over the elements in a collection. There are four elements required for such a construct:

1. **Loop**: block of code that gets repeated (note that when passed to `Kernal#loop` this creates an [inner scope](variable_scope.md#scopes-with-a-block)).
2. **Counter**: variable that tracks the number of iterations
3. Some way to **retrieve* the current value (current element in the collection)
4. Some way to exit the loop (such as a `break` statement)

```ruby
array = ['one', 'two', 'three', 'four']
counter = 0

loop do
  puts array[counter]
  counter+= 1
  break if counter >= array.length
end

# => 'one'
# => 'two' ... etc
```

The iteration counter is often used to represent index, since they both start at 0 and are incremented by 1 each time through the loop. In this case, the length of the collection will represent an index that is out of bounds, so make sure to break out of the loop before that is reached.

### Iterating over Hashes

Hashes have key-value pairs, rather than indexes, so a simple counter variable can't be used to iterate over the hash. Instead, create an array containing all the keys in the hash (`Hash#keys`). Then, iterate over the array of keys, and save each key into a variable. Finally, use that variable to retrieve the appropriate value of the hash.

```ruby
books_in_stock = {
  'sci-fi' => 125,
  'romance' => 156,
  'literature' => 231
}

books = books_in_stock.keys
counter = 0

loop do
  break if counter >= books_in_stock.length
  current_book = books[counter]
  current_book_quantity = books_in_stick[current_book]
  puts "The store has #{current_book_quantity} #{current_book} books."
  counter += 1
end
```

## Selection and Transformation

Selection and transformation are both processes that add a _set of rules_ to the four basic elements of looping. **Selection** uses these rules to determine _which elements_ are selected. **Transformation** uses the rules to determine _how_ to transform each element.

### Selection

Selection describes the process of picking certain elements out of a collection based on some condition or expression that evaluates to a Boolean value.

For example, the code below _selects_ elements from the original array and adds them to a new array based on the conditional (is the element even?), returning a new array consisting of the sub-set of elements that are even.

```ruby
array = [1, 2, 3, 4, 5, 6, 7]
counter = 0
evens = []

loop do
  break if counter >= array.length
  if array[counter].even?
    evens << array[counter]
  end
  counter += 1
end

p array   # => [1, 2, 3, 4, 5, 6, 7]
p evens   # => [2, 4, 6]
```

### Transformation

Transformation describes the process of manipulating each element in the collection, and using some evaluated expression to transform each element. Unless the process is stopped early, it will return the same amount of elements in the original collection. It is considered bad practice to modify the length of a collection during transformation.

The code below _destructively_ transformed an array by iterating through and adding 1 to each element by using [element assignment](#element-assignment).

```ruby
array = [1, 2, 3, 4, 5, 6, 7]
counter = 0

loop do
  break if counter >= array.length
  array[counter] += 1
  counter += 1
end

array   # => [2, 3, 4, 5, 6, 7, 8]
```

When performing transformation be aware of what's returned. Is it a new collection of transformed values or has the original collection been mutated?

### Extracting to Methods

Both selection and transformation are _specific actions_ that lend themselves to being separated into a discreet method. Hence the previous language of _returning_ a new or the original collection based on the rules of the method itself.

Because of Ruby's implied return, end methods with what you want the return values to me.

Methods can contain criteria for _both_ transformation and selection, in which case they will only transform a _subset_ of elements in the collection being manipulated.

Make these methods as generic as possible by allowing for additional parameters to specify some criteria for selection or transformation.

```ruby
# not a very generic method, returns new array
def adds_one(numbers)
  counter = 0
  added_numbers = []

  loop do
    break if counter >= numbers.length
    added_numbers << numbers[counter] + 1
    counter += 1
  end

  added_numbers
end

# more generic, you can choose what to add
def adds(numbers, to_add)
  counter = 0
  added_numbers = []

  loop do
    break if counter >= numbers.length
    added_numbers << numbers[counter] + to_add
    counter += 1
  end

  added_numbers
end
```

In general, don't hard code what you don't have to. Using a descriptive variable makes code easier to read as well as more versatile in the long run.

## Sorting

**Sorting** is the process of putting items in a collection into some kind of order based on a rule or set of rules. This is mainly done with arrays, because arrays are the data structure used when the order of elements is important, and each element in an array is access via an ordered index.

While strings do not necessarily have access to sorting methods, since they are easily converted into arrays and back again, sorting operations are easily accomplished on them via this conversion.

The process of sorting is accomplished by _comparing each element in the collection with the others_ and ordering them _based on the result_ of that comparison.

### Comparison

Ruby uses **the comparison method** `<=>` to evaluate comparisons between elements in a collection. Expressions using `<=>` need to be performed on two object of the same data type. They then return either a `-1`, `0`, or `1` to indicate whether the first object is greater than, less than, or equal to the second object.

If the two operands are of different data types, they cannot be compared and `nil` is returned. The value returned by `<=>` is used by sorting methods to determine the order in which to place the items. Therefore, if `<=>` returns `nil`, the program will throw an `ArgumentError`.

```ruby
2 <=> 1       # => 1 (first operand is greater than second)
1 <=> 2       # => -1 (first operand is less than second)
2 <=> 2       # => 0 (both operands are equal)

'b' <=> 'a'   # => 1 (greater than)
'a' <=> 'b'   # => -1 (less than)
'a' <=> 'a'   # => 0  (equal)

1 <=> 'a'     # => nil (does not compare)
```

Different object types have different implementations for `<=>`. Numerical values, such as integers and floats, are relatively straightforward. The numerical values are compared according to where they lie on a standard number line. `2` is greater than `1`. `3` is less than `24`.

Strings, however, are compares in **ASCIIbetical Order**.

- Uppercase letters always come before lowercase (i.e. `'A'` is less than `'a'`). This holds true for all uppercase letters (`'Z'` is less than `'a'`).
- Digits and most punctuation marks come before letters
- Accented and other characters that are part of the extended ASCII table come after the main alphanumeric characters in the standard ASCII table.

Strings are compared _character by character_ and are ordered as they would be found in a dictionary.

- String beginning with a "lesser" letter in the ASCII table will come before those with a "greater" letter in the ASCII table (i.e. `'apple', 'assurance'` before `'banana'`).
- In the case where all comparable characters are equal, but one string is longer than the other, the longer string will be considered to be "greater". (i.e. `'crab'` before `'crabby'`).

```ruby
'a' <=> 'b'         # => -1 (less than)
'apple' <=> 'ape'   # => 1 (greater than)
'cat' <=> 'catty'   # => -1 (less than)

words = %w(card soap knife crab soapy coin sand king kill)
words.sort
# => ["card", "coin", "crab", "kill", "king", "knife", "sand", "soap", "soapy"]
```

Arrays are also compared element by element using `Array#<=>`. Similarly with `String#<=>`, when all the comparable elements in two arrays of different length are equal, the larger array will be considered to be "greater than".

```ruby
[0, 1, 2] <=> [1, 1, 2]     # => -1 (less than)
[1, 1, 2] <=> [1, 2, 3]     # => -1 (less than)
[1, 1, 2, 3] <=> [1, 1, 2]  # => 1 (greater than)

[[2, 4], [2, 1, 4], [0, 1, 2], [3, 2, 0], [0, 1], [3, 2, 5]].sort
# => [[0, 1], [0, 1, 2], [2, 1, 4], [2, 4], [3, 2, 0], [3, 2, 5]]
```

### Sorting Methods

See: [Sorting Methods](collection_methods.md#sorting-methods)

## Nested Data Structures

A **nested data structure** is any kind of collection that contains other collection(s) as one or more of it's elements. These can include; an array in which each element is a sub-array, hashes in which either the key or the value (more likely the value) is another hash, arrays whose elements are hashes, or hashes whose keys or values are arrays. Nested data structures are not restricted to 2-levels, such as an array containing and array containing an array.

### Referencing Collection Elements

Each element of a collection, whether an upper level collection with collections as it's elements, or an inner collection, uses the [element reference](#element-reference) method standard for that particular data type. To reference specific elements of an inner sub-collection, chain element reference together.

```ruby
# nested arrays
array = [[1, 2], [3, 4], [5, 6]]
array[0]                # => [1, 2]
array[0][1]             # => 2
array[0, 2]             # => [[1, 2], [3, 4]]
array[0, 2][1][0]       # => 3

# an array of hashes
people = [{name: "Anne", color: "purple"}, {name: "Bill", color: "blue"}]
people[0]               # => {name: "Anne", color: "purple"}
people[0][:name]        # => "Anne"
people[0][:name][-1]    # => "e"

# a hash of arrays
words = { nouns: %w(shoe ear tea book), verbs: %w(run swim jump dance) }
words[:nouns]           # => ["shoe", "ear", "tea", "book"]
words[:nouns][0]        # => "shoe"
words[:nouns][2..-1]    # => ["tea", "book"]
words[:nouns][0][0]     # => "s"

# a hash of hashes
friends = { "Ashley" => { job: 'designer', birthday: '8/23' }, 
            "Joe" => { job: 'bartender', birthday: '7/12' },
            "Sue" => { job: 'producer', birthday: '2/22' }}
friends["Joe"]          # => { job: 'bartender', birthday: '7/12' }
friends["Joe"][:job]    # => "bartender"
friends["Joe"][:job][0] # => "b"

# more complex structures
game_data = { player: { hand: [{ suit: 'Clubs', value: 'Ace'}, 
                               { suit: 'Hearts', value: 'Queen'}]
                          total: 21,
                          score: 0 },
              dealer: { hand: [{ suit: 'Clubs', value: '10'},
                               { suit: 'Spades', value: '9'},
                               { suit: 'Hearts', value: '2'}]
                          total: 21,
                          score: 0 } }
# complex structures like this help extract data in more complex programs
game_data[:player][:hand] # => [{ suit: 'Clubs', value: 'Ace'}, { suit: 'Hearts', value: 'Queen'}]
game_data[:player][:score] # => 0
game_data[:player][:hand].each { |card| p card }
# => { suit: 'Clubs', value: 'Ace' }
# => { suit: 'Hearts', value: 'Queen'}
```

### Updating Collection Elements

You can chain together [element reference](#element-reference) with [element assignment](#element-assignment) to reassign individual collection elements anywhere within a nested data structure. Note that reassigning or updating individual collection elements **is a destructive action that permanently modifies the collection**.

```ruby
array = [[1, 1], [3, 4], [5, 6]]
array[0][1] = 2   # array[0] is element reference, returns [1, 1]
                  # [1] = 2 is element reassignment we chain onto the return value [1, 1]
array             # => [[1, 2], [3, 4], [5, 6]]
```

You can insert elements into a sub-array by chaining [element reference](#element-reference) with _appending an element_.

```ruby
words = { nouns: %w(shoe ear tea book), verbs: %w(run swim jump dance) }
words[:nouns] << "gum"  # => ["shoe", "ear", "tea", "book", "gum"]

# words[:nouns] is element reference, returns ["shoe", "ear", "tea", "book"]
# << "gum" Array#<< method is chained onto this return value

words
# => {:nouns=>["shoe", "ear", "tea", "book", "gum"], :verbs=>["run", "swim", "jump", "dance"]}
```

It's possible to add another array as an element of a sub-array, creating a **three layer** nested data structure.

```ruby
array = ["layer one", ["layer two"]]
array[0]    # => "layer one"
array[1]    # => ["layer two"]
array[1][0] # => "layer two"

array[1] << ["layer three"]
array
# => ["layer one", ["layer two", ["layer three"]]]
array[1][1][0]  # => "layer three"
```

To add key-value pairs to hashes nested within an array, first reference the desired hash by using array element reference, then update the hash using proper hash syntax.

```ruby
people = [{name: "Anne", color: "purple"}, {name: "Bill", color: "blue"}]

people[0][:season] = "Summer"
# people[0] is array element reference returing the value {name: "Anne", color: "purple"}
# [:season] = "Summer" adds the key :season with the associated value "Summer" to the returned hash

people
# => people = [{name: "Anne", color: "purple", season: "Summer"}, {name: "Bill", color: "blue"}]
```

### Variable Reference in Nested Collections

Variables can reference inner collections directly. In this case, they act as pointers and _point_ to that object in memory. Both element reference and the variable, then, are two different ways of referencing the same object.

Any changes made to the variable that references an inner collection will be reflected in the collection as a whole, since they both reference the same object.

```ruby
a = [1, 2]
b = [3, 4]
array = [a, b]
array                                 # => [[1, 2], [3, 4]]
array[0].object_id == a.object_id     # => true

a[0] = 0
a                                     # => [0, 2]
a[0]                                  # => [0, 2]
array                                 # => [[0, 2], [3, 4]]
```

### Shallow Copy

The methods `dup` and `clone` are ways of creating copies of various Ruby objects. However, _only the object the method is called on is copied_. This means that if the calling object contains other objects (such as in a collection or nested collection), those objects are _shared_ rather than copied. The elements within a copied collection will reference the same object in memory as the original collection, and this is known as a **shallow copy**.

```ruby
arr_a = %w(ant bat cat)
arr_b = arr_a.dup

arr_a.object_id == arr_b.object_id    # => false
arr_a[0].object_id == arr_b[0].object_id # => true
```

Calling a destructive method on an individual element within a collection that is a shallow copy will result in a change to both collections referenced by each variable `arr_a` and `arr_b`. This is because every element in `arr_b` is a reference to the object references by the corresponding element in `arr_a`.

```ruby
arr_a = %w(ant bat cat)
arr_b = arr_a.dup

arr_b[1].upcase!
arr_b             # => ["ant", "BAT", "cat"]
arr_a             # => ["ant", "BAT", "cat"]
```

Calling a destructive method on the collection copy _as a whole_ will cause the collection itself to be changed, rather than the individual elements. In this case, the original collection `arr_a` will remain unchanged.

```ruby
arr_a = %w(ant bat cat)
arr_b = arr_a.dup

arr_b.map! { |word| word.upcase } 
# note that we do not use a destructive method here, and instead return a new string object
# This gets assigned to each element in arr_b, breaking the link between shared elements

arr_b # => ["ANT", "BAT", "CAT"]
arr_a # => ["ant", "bat", "cat"]
```

However, we can still destructively change the original copied collection within a method call on the copied collection as a whole, if we mutate any of the elements within a block that gets passed to it.

```ruby
arr_a = %w(ant bat cat)
arr_b = arr_a.dup

arr_b.each { |word| word.upcase! }
# here we call the destructive method upcase! on each element
# it returns the same object that called it
# the link between elements in arr_a and arr_b is never broken

arr_b # => ["ANT", "BAT", "CAT"]
arr_a # => ["ANT", "BAT", "CAT"]
```

If you are working with an outer array or hash, destructive methods will act like reassignment, and break the link between shared objects. Using destructive methods on inner objects or inner collections, on the other hand, will cause shared objects to be changed permanently _wherever_ they are referenced.

### Freezing Objects

Ruby objects can be **frozen** to prevent them from being modified. To do so, we use the `freeze` method.

```ruby
string = 'hello'
string.freeze
string << ' world'
# => FrozenError: cannot modify frozen string
```

Only mutable objects can be frozen; immutable objects, since they cannot be changed, are ostensibly already frozen. You can check to see if an object is frozen using `frozen?`.

Like `dup` and `clone`, the `freeze` method _only freezes the object that calls it_. Therefore, if `freeze` is called on a collection that contains other objects as it's elements, those object **will not** be frozen.

Note that reassignment of individual elements within a frozen collection will not work, because it creates a new object and tries to add it to the collection as a whole.

```ruby
array = ["apple", "book", "car", "dog"]
array.freeze

array << "ear"            # => FrozenError
array[0] = 'ant'          # => FrozenError (reassignment)
array[0] << 'sss'         # => 'applesss'
array                     # => ["applessss", "book", "car", "dog"]

# nested array
array = [[1, 2], [3]].freeze
array[1] << 4
array                     # => [[1, 2], [3, 4]]
```

If you use `clone` on a frozen object it will preserve the frozen state of that object, and you will not be able to modify the original or the copy. `dup`, however, **does not** preserve the frozen state of any object it copies, so you will be able to change the copy.

```ruby
arr_a = %w(apple book car).freeze
arr_b = arr_a.clone
arr_b << 'dog'            # => FrozenError

arr_c = %w(dog egg fig).freeze
arr_d = arr_c.dup
arr_d << 'green'
arr_d                     # => ['dog', 'egg', 'fig', 'green']
arr_c                     # => ['dog', 'egg', 'fig']
```

# Collection Methods

- [Each, Select, and Map](#each-select-and-map)
  - [Each](#each)
  - [Select](#select)
  - [Map](#map)
- [Enumerable Methods](#enumerable-methods)
  - [any?](#any)
  - [all?](#all)
  - [each_with_index](#each_with_index)
  - [each_with_object](#each_with_object)
  - [first](#first)
  - [include?](#include)
  - [partition](#partition)
- [Sorting Methods](#sorting-methods)
  - [sort](#sort)
  - [sort_by](#sort_by)
- [Comparison Methods](#comparison-methods)
  - [min](#min)
  - [min_by](#min_by)
  - [max](#max)
  - [max_by](#max_by)
  - [minmax](#minmax)
  - [minmax_by](#minmax_by)

## Each, Select, and Map

### Each

`each` comes from `Enumerable#each`, but both arrays and hashes have their own variation (`Array#each` and `Hash#each`).

`each` accomplishes iteration _only_, just as using a basic loop would. When invoked, it gets passed a block. Each element in the calling collection is then passed into the block on each iteration and assigned to (one of) the block parameter(s). `each` always returns the original collection, and does not utilize the return value of the block. If you need to use that return value, you need to capture it in a variable. For this reason, it's best to use `each` when you need to generate some kind of side-effect, rather than directly for transformation or selection.

```ruby
# each with an array
names = ["George", "Bobbi", "Joel", "Susan"]
names.each do |name|
  puts "My name is #{name}."
end
# Outputs:
  # => "My name is George."
  # => "My name is Bobbi."
  # => "My name is Joel."
  # => "My name is Susan."
# Returns: ["George", "Bobbi", "Joel", "Susan"]

# each with a hash
birthdays = { "George" => "9/4", "Bobbi" => "2/22", "Joel" => "3/15" }
birthdays.each do |name, birthday|
  puts "#{name}'s birthday is on #{birthday}."
end
# Outputs:
  # => "George's birthday is on 9/4."
  # => "Bobbi's birthday is on 2/22."
  # => "Joel's birthday is on 3/15."
# Returns: { "George" => "9/4", "Bobbi" => "2/22", "Joel" => "3/15" }
```

### Select

`select`, like `each`, comes from `Enumerable#select`, but both arrays and hashes have their oven versions (`Array#select` and `Hash#select`).

`select` is a good choice for the process of _selection_. When invoked, it gets passed a block. Each element in the calling collection is the passed to (one of) the block parameter(s) on each iteration.`select` will the return _a new collection_ of all the elements that have returned a _truthy_ value when passed to the block.

Note that if there is no way for the block to return a `false` or `nil` value, all the elements in the calling collection will get selected. It's best to use a conditional (which will return `nil` if it isn't run) or expression that evaluates to some kind of Boolean.

```ruby
# select with an array
numbers = [1, 2, 3, 4, 5, 6, 7, 8]
evens = numbers.select { |num| num.even? }
p numbers # => [1, 2, 3, 4, 5, 6, 7, 8]
p evens   # => [2, 4, 6, 8]

# select with a hash
ages = { mom: 65, dad: 70, daughter: 30, son: 25, grandma: 89 }
under_30 = ages.select { |_, age| age < 30 }
p under_30  # => { son: 25 }
```

### Map

`map` comes from `Enumerable#map` and while there is a specific one for arrays (`Array#map`) hashes use the one they have access to through the Enumerable module.

`map` returns a _new **array**_ of transformed collection elements. Note that it _always_ returns an array, even when the calling collection is a hash. When invoked, it gets passed a block. On each iteration through the collection, the current element is passed to the block and assigned to (one of) the block parameter(s). Then, `map` will use the return value of the block for _transformation_, by placing the return value of the block into a new collection for each element in the calling collection.

```ruby
# map with an array
names = ["ginni", "dylan", "nancy"]
names.map { |name| name.capitalize }
# => ["Ginni", "Dylan", "Nancy"]

# map with a hash
ages = { mom: 65, dad: 70, daughter: 30, son: 25, grandma: 89 }
ages.map { |_, age| age - 5 }
# => [60, 65, 25, 20, 84]
```

## Enumerable Methods

Collection types like Arrays, Hashes, and Ranges have access to Enumerable methods, but object likes Strings do not.

### any?

`any?` is good for determining if _any_ items in a collection meet a certain criteria. It is passed a block when invoked, and will return `true` if the block _ever_ returns a value other than `false` or `nil`.

If no block is given, Ruby will has an implicit block `{ |obj| obj }`, that will cause `any?` to return `true` if at least one of the objects in the collection are `false` or `nil`.

A pattern can also be supplied (with no block) as an argument, and the method will return whether or not the pattern matches with any of the elements in the collection.

```ruby
words = ["how", "now", "brown", "cow"]
words.any? { |word| word.length > 3 }       # => true
words.any? { |word| word.length > 4 }       # => false
words.any? { |word| word.include?('a') }    # => false
word.any?(/d/)                              # => false

array = [0, 1, 2, 3, nil]
array.any?                                  # => true
[].any?                                     # => false
```

### all?

`all?` is good for determining if _all_ the items in a collection meet a certain criteria. It is passed a block when invoked, and will return `true` _only_ if the block never returns a `false` or `nil`.

As with `any?` you can call it without a block for the implied `{ |obj| obj }` evaluation or provide it with a pattern argument to match. In either case, the method will return `true` only if _all_ the elements in the calling collection match the given pattern or return a truthy value in the implied block.

```ruby
words = ["how", "now", "brown", "cow"]
words.all? { |word| word.length > 3 }       # => false
words.all? { |word| word.length >= 3 }      # => true
words.all? { |word| word.include?('o') }    # => true
word.all?(/[a-z]/)                          # => true

array = [0, 1, 2, 3, nil]
array.all?                                  # => false
```

### each_with_index

`each_with_index` is best used when you need to iterate over a collection and also need to track, use, or manipulate either the index number of each element, or the iteration number (index can serve in place of both). It works similarly to [each](#each), except a block parameter is assigned to the index number of the current element in the calling collection.

When `each_with_index` is called on a hash, the first argument in the block becomes an array representing each key-value pair, and the second argument is the index number.

Like [each](#each), `each_with_index` always returns the original calling collection, regardless of the block's return value.

```ruby
rhymes = {}
words = ['hero', 'son', 'shoe', 'free']
words.each_with_index { |word, index| rhymes[index] = word }
# Returns => ['hero', 'son', 'shoe', 'free']
p rhymes
# => { 0 => 'hero', 1 => 'son', 2 => 'shoe', 3 => 'free' }
```

### each_with_object

`each_with_object` takes both a block and an arbitrary object as arguments. It iterates the given block for each element in the calling collection, and returns the object that was initially given as an argument. This can be very useful in converting data structures that aren't inherently structured similarly, giving you a way to manipulate two collections at once.

```ruby
# creating an array of evens from a range of nums
(1..10).each_with_object([]) { |num, array| array << num * 2 }
# => [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

# convert a single dimension array to a hash
words = ['hero', 'son', 'shoe', 'free']
counter = 0

words.each_with_object({}) do |word, hash|
  hash[counter] = word
  counter += 1
end
#  => {0=>"hero", 1=>"son", 2=>"shoe", 3=>"free"}
```

### first

`first` can return either the first element in a collection or a group of the first elements in a collection, if the number of elements desired is given as an argument. If the calling collection is empty, the method will return `nil`, unless the optional argument is given in which case it will return an empty array.

`first` always returns these items in the form an array, even if the calling collection is a hash.

```ruby
nums = [1, 2, 3, 4, 5]
nums.first                # => 1
nums.first(3)             # => [1, 2, 3]
[].first                  # => nil
[].first(2)               # => []

rhymes = {0=>"hero", 1=>"son", 2=>"shoe", 3=>"free"}
rhymes.first              # => [0, 'hero']
rhymes.first(2)           #  => [[0, "hero"], [1, "son"]]
```

### include?

Good for determining if a collection contains a particular object as a member. `include?` will return `true` if the object supplied as an argument is considered equal (using `==`) to any elements in the calling collection.

When called on a hash, only checks the _values_ of the key value pairs to see if the argument exists within them.

```ruby
nums = [0, 1, 2, 3]
nums.include?(3)          # => true
nums.include?(4)          # => false

rhymes = {0=>"hero", 1=>"son", 2=>"shoe", 3=>"free"}
rhymes.include?(0)        # => false
rhymes.include?('hero')   # => true
```

### partition

Useful if you need to split a collection into two sub-groups based on some criteria. `partition` is passed a block and returns two arrays, nested within a larger encompassing array. The first array will contain those elements within the calling collection for whom the block returns a truthy value, and the second array will contain those elements within the calling collection for whom the block returns `false` or `nil`.

```ruby
words = %w(Mary bowtie California pasta tacos Ohio)
words.partition { |word| (word =~ /[A-Z]/) == 0 }
# => [["Mary", "California", "Ohio"], ["bowtie", "pasta", "tacos"]]

# capturing the above arrays using parallel assignment
proper_nouns, nouns = words.partition { |word| (word =~ /[A-Z]/) == 0 }
p proper_nouns  # => ["Mary", "California", "Ohio"]
p nouns         # => ["bowtie", "pasta", "tacos"]
```

You can even capture the two arrays returns in separate variables using **parallel assignment**

```ruby
# super simple parallel assignment
a, b = [1, 2]

# using partition
odds, evens = (1..10).partition { |num| num.odd? }
p odds  # => [1, 3, 5, 7, 9]
p evens # => [2, 4, 6, 8, 10]
```

## Sorting Methods

### sort

`sort` returns an array containing all the items in the calling collection sorted. It can be called either with or without a block.

When called without a block, it will use the version of `<=>`specific to the object types within the calling collection to determine the order of the items to be returned.

Calling `sort` with a block gives a way to control how the items are sorted. The block takes two arguments, the two items to be compared, and the return value of the block must be `-1`, `1`, or `0` (i.e. it should probably use `<=>`). You can put additional code in the block if you need to, as long as its return value is one of those supported by `<=>`.

```ruby
nums = [3, 2, 6, 4, 8, 1, 5, 9, 0]

# sort without a block
nums.sort
# => [0, 1, 2, 3, 4, 5, 6, 8, 9]

# return an array in descending order
nums.sort { |a, b| b <=> a }
# => [9, 8, 6, 5, 4, 3, 2, 1, 0]

# compare by other criteria
['aaa', 'a', 'aaaaa', 'aa', 'aaaa'].sort do |a, b|
  a.size <=> b.size
end
# => ["a", "aa", "aaa", "aaaa", "aaaaa"]

# block with additional code
['aaa', 'a', 'aaaaa', 'aa', 'aaaa'].sort do |a, b|
  puts "a has #{a.size} letters and b has #{b.size} letters"
  a.size <=> b.size
end
```

Note that `Array#sort` has a destructive equivalent `Array#sort!`, but `Enumerable#sort` (which is the method available to Hashes and other collections) does not have a destructive equivalent.

### sort_by

`sort_by` is useful for sorting items via a specific criteria, or sorting items in a hash. It takes a block, and each element in the calling collection is assigned to (one of) the block parameter(s). Then, it uses the return value of the block to determine how the collection should be sorted. `sort_by` always returns an array.

Unlike `sort`, the block does not need to return `-1`, `1`, `0` or `nil`, only the criteria by which you want the collection to be sorted.

```ruby
# sort by digit in the 1's place
[123, 432, 543, 642, 543, 256].sort_by do |num|
  num.digits.first
end
# => [432, 642, 123, 543, 543, 256]

# sort by area code
contacts = {
  Jenny: '230-867-5309',
  Skylar: '432-555-5555',
  joe: '230-432-1234',
  Jimmy: '123-123-1234'
}
contacts.sort_by do |_, number|
  number.split('-')[0]
end
# => [[:Jimmy, "123-123-1234"], [:Jenny, "230-867-5309"], [:joe, "230-432-1234"], [:Skylar, "432-555-5555"]]

# sort by name in alphabetical order
contacts.sort_by do |name, _|
  name.capitalize
end
# => [[:Jenny, "230-867-5309"], [:Jimmy, "123-123-1234"], [:joe, "230-432-1234"], [:Skylar, "432-555-5555"]]
```

Note that `Array#sort_by` has a destructive equivalent `Array#sort_by!`, but `Enumerable#sort_by` (which is the method available to hashes and other collections) does not have a destructive equivalent.

## Comparison Methods

### min

`Enumerable#min` returns the object in the calling collection with the "minimum" value. You can pass it a block to determine how elements are compared. The block takes two arguments (items being compared) and must return either `-1`, `1`, or `0`. You can also pass it an argument `n` in order to return `n` number minimum elements from the calling collection. This subgroup will be returned as a sorted array. The argument can be used both with and without the block.

```ruby
words = %w(cantaloupe apple durian bananas)

# default uses <=> to compare collection elements
words.min                                 # = > "apple"
words.min(2)                              # => ["apple", "bananas"]

# with a block
words.min { |a, b| a.size <=> b.size }    # => "apple"
words.min(2) { |a, b| a.size <=> b.size } # => ["apple", "durian"]
```

### min_by

`Enumerable#min_by` is passed a block when invoked, and returns the element from the calling collection for which the block returns the minimum value. Like `Enumerable#min` you can also pass it an argument, `n`, in order to return `n` number of minimum elements as an array sorted by the value given by the block.

```ruby
words = %w(cantaloupe apple durian)

# sort by amount of vowels
words.min_by { |word| word.count("aeiou") }
# => "apple"
words.min_by(2) { |word| word.count("aeiou") }
# => ["apple", "durian"]
```

### max

`Enumerable#max` returns the object in the collection with the maximum value. By default, the method uses `<=>` to compare elements within the calling collection. Alternatively, you can pass it a block to determine how elements are compared. The block takes two arguments (the items being compared) and must return either `-1`, `1`, or `0`. The method also takes optional argument `n`, either with or without the block, which causes the method to return `n` number maximum elements in a sorted array.

```ruby
words = %w(cantaloupe apple durian bananas)

# default uses <=> to compare collection elements
words.max                                 # = > "durian"
words.max(2)                              # => ["durian", "cantaloupe"]

# with a block
words.max { |a, b| a.size <=> b.size }    # => "cantaloupe"
words.max(2) { |a, b| a.size <=> b.size } # => ["cantaloupe", "bananas"]
```

### max_by

`Enumerable#max_by` is passed a block when invoked, and returns the element from the calling collection for which the block returns the maximum value. It also takes an optional argument, `n`, which when given causes the method to return `n` number of maximum elements in an array sorted by the return value of the block.

```ruby
words = %w(cantaloupe apple durian)

# sort by amount of vowels
words.max_by { |word| word.count("aeiou") }
# => "cantaloupe"
words.max_by(2) { |word| word.count("aeiou") }
# => ["cantaloupe", "durian"]
```

### minmax

`Enumerable#minmax` returns a 2 element array which contains both the minimum and maximum values in the calling collection. By default, the method will evaluate all elements with `<=>`. Alternatively, you can pass it a block to determine how elements should be compared. The block takes two arguments (the items to compare) and should return a value of `-1`, `1`, or `0`.

```ruby
words = %w(cantaloupe apple durian bananas)

words.minmax
# => ["apple", "durian"]
words.minmax { |a, b| a.size <=> b.size }
# => ["apple", "cantaloupe"]
```

### minmax_by

`Enumerable#minmax_by` is passed a block when invoked. It then returns a two element array in which the first element is that for which the block returns the minimum value, and the second element is that for which the block returns the maximum value.

```ruby
words = %w(cantaloupe apple durian bananas)

words.minmax_by { |word| word.count("aeiou") }
# => ["apple", "cantaloupe"]
```

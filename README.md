Ruby::Enum
==========

[![Gem Version](http://img.shields.io/gem/v/ruby-enum.svg)](http://badge.fury.io/rb/ruby-enum)
[![Build Status](http://img.shields.io/travis/dblock/ruby-enum.svg)](https://travis-ci.org/dblock/ruby-enum)
[![Dependency Status](https://gemnasium.com/dblock/ruby-enum.svg)](https://gemnasium.com/dblock/ruby-enum)
[![Code Climate](https://codeclimate.com/github/dblock/ruby-enum.svg)](https://codeclimate.com/github/dblock/ruby-enum)

Enum-like behavior for Ruby, heavily inspired by [this](http://www.rubyfleebie.com/enumerations-and-ruby) and improved upon [another blog post](http://code.dblock.org/how-to-define-enums-in-ruby).

## Usage

``` ruby
class Colors
  include Ruby::Enum

  define :RED, "red"
  define :GREEN, "green"
end
```

### Referencing

``` ruby
Colors::RED # "red"
Colors::GREEN # "green"
Colors::UNDEFINED # raises Ruby::Enum::Errors::UninitializedConstantError
Colors.keys # [ :RED, :GREEN ]
Colors.values # [ "red", "green" ]
Colors.to_h # { :RED => "red", :GREEN => "green" }
```

### All `Enumerable` methods are supported.

#### Iterating

``` ruby
Colors.each do |key, enum|
  # key and enum.key is :RED, :GREEN
  # enum.value is "red", "green"
end
```

#### Mapping

``` ruby
Colors.map do |key, enum|
  # key and enum.key is :RED, :GREEN
  # enum.value is "red", "green"
  [enum.value, key]
end

# => [ ['red', :RED], ['green', :GREEN] ]
```

#### Reducing

``` ruby
Colors.reduce([]) do |arr, (key, enum)|
  # key and enum.key is :RED, :GREEN
  # enum.value is "red", "green"
  arr << [enum.value, key]
end

# => [ ['red', :RED], ['green', :GREEN] ]
```

#### Sorting
``` ruby
Colors.sort_by do |key, enum|
  # key and enum.key is :RED, :GREEN
  # enum.value is "red", "green"
  enum.value
end

# => [ [:GREEN, #<Colors:...>], [:RED, #<Colors:...>] ]
```

### Several hash-like methods are supported.

#### Retrieving keys and values

``` ruby
Colors.keys
# => [:RED, :GREEN]

Colors.values
# => ["red", "green"]
```

#### Mapping keys to values

``` ruby
Colors.key?(:RED)
# => true

Colors.value(:RED)
# => "red"

Colors.key?(:BLUE)
# => false

Colors.value(:BLUE)
# => nil
```

#### Mapping values to keys

``` ruby
Colors.value?('green')
# => true

Colors.key('green')
# => :GREEN

Colors.value?('yellow')
# => false

Colors.key('yellow')
# => nil
```


### Duplicate enumerator keys or duplicate values

Defining duplicate enums will raise a `Ruby::Enum::Errors::DuplicateKeyError`. Moreover a duplicate
value is not allowed. Defining a duplicate value will raise a `Ruby::Enum::Errors::DuplicateValueError`.
The following declarations will both raise an exception:

```ruby
  class Colors
    include Ruby::Enum

    define :RED, "red"
    define :RED, "my red" # will raise a DuplicateKeyError exception
  end

  # The following will raise a DuplicateValueError
  class Colors
    include Ruby::Enum

    define :RED, 'red'
    define :SOME, 'red' # Boom
  end
```

The `DuplicateValueError` exception is thrown to be consistent with the unique key constraint.
Since keys are unique there is no way to map values to keys using `Colors.value('red')`

### Inheritance behavior

Inheriting from a `Ruby::Enum` class, all defined enums in the parent class will be accessible in sub classes as well.
Sub classes can also provide extra enums as usual.

## Contributing

You're encouraged to contribute to this gem. See [CONTRIBUTING](CONTRIBUTING.md) for details.

## Copyright and License

Copyright (c) 2013-2016, Daniel Doubrovkine and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).

## Related Projects

* [typesafe_enum](https://github.com/dmolesUC3/typesafe_enum): Typesafe enums, inspired by Java.
* [renum](https://github.com/duelinmarkers/renum): A readable, but terse enum.

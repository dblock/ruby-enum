Ruby::Enum
==========

[![Build Status](https://travis-ci.org/dblock/ruby-enum.png)](https://travis-ci.org/dblock/ruby-enum)

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

## Contributing

You're encouraged to contribute to this gem.

* Fork this project.
* Make changes, write tests.
* Updated [CHANGELOG](CHANGELOG.md).
* Make a pull request, bonus points for topic branches.

## Copyright and License

Copyright (c) 2013, Daniel Doubrovkine and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).

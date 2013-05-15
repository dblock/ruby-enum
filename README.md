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

### Iterating

``` ruby
Colors.each do |key, enum|
  # key and enum.key is :RED, :GREEN
  # enum.value is "red", "green"
end
```

## Contributing

You're encouraged to contribute to this gem.

* Fork this project.
* Make changes, write tests.
* Updated CHANGELOG.
* Make a pull request, bonus points for topic branches.

## Copyright and License

Copyright Daniel Doubrovkine and Contributors, 2013

[MIT License](LICENSE.md)


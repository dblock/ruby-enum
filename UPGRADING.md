# Upgrading Ruby::Enum

## Upgrading to >= 1.2.0

### Inheritance & `keys`, `key?`, `value?`, `key`, `value`, `to_h`, `parse` and `each`

This only applies to classes that inherit from another which is a `Ruby::Enum`.

Prior to version `1.2.0`, only `values` enumerated enums defined in the entire class hierarchy; `keys`, `key?`, `value?`, `key`, `value`, `to_h`, `parse` and `each` only considered enums defined directly on the class, silently ignoring anything defined in a superclass.

As of version `1.2.0`, these methods behave consistently with `values` and also enumerate/consider enums defined anywhere in the class hierarchy, ancestors first. A subclass may still redefine a key or value already used by a superclass; its own definition takes precedence.

``` ruby
class PrimaryColors
  include Ruby::Enum

  define :RED, 'RED'
  define :GREEN, 'GREEN'
end

class RainbowColors < PrimaryColors
  define :ORANGE, 'ORANGE'
end
```

`gem 'ruby-enum', '< 1.2.0'`

``` ruby
RainbowColors.keys       # => [:ORANGE]
RainbowColors.key?(:RED) # => false
```

`gem 'ruby-enum', '>= 1.2.0'`

``` ruby
RainbowColors.keys       # => [:RED, :GREEN, :ORANGE]
RainbowColors.key?(:RED) # => true
```

See [#49](https://github.com/dblock/ruby-enum/issues/49) for more information.

## Upgrading to >= 0.9.0

### Inheritance & `Ruby::Enum.values`

This only applies to classes that inherit from another which is a `Ruby::Enum`.

Prior to version `0.9.0`, the `values` class method would enumerate only the
values defined in the class.

As of version `0.9.0`, the `values` class method enumerates values defined in
the entire class heirarchy, ancestors first.

``` ruby
class PrimaryColors
  include Ruby::Enum

  define :RED, 'RED'
  define :GREEN, 'GREEN'
  define :BLUE, 'BLUE'
end

class RainbowColors < PrimaryColors
  define :ORANGE, 'ORANGE'
  define :YELLOW, 'YELLOW'
  define :INIDGO, 'INIDGO'
  define :VIOLET, 'VIOLET'
end
```

`gem 'ruby-enum', '< 0.9.0'`

``` ruby
RainbowColors.values # ['ORANGE', 'YELLOW', 'INIDGO', 'VIOLET']
```

`gem 'ruby-enum', '>= 0.9.0'`

``` ruby
RainbowColors.values # ['RED', 'ORANGE', 'YELLOW', 'GREEN', 'BLUE', 'INIDGO', 'VIOLET']
```

See [#29](https://github.com/dblock/ruby-enum/pull/29) for more information.

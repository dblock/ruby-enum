# Upgrading RubyEnum::Enum

## Upgrading to >= 2.0.0

### Module renamed from `Ruby::Enum` to `RubyEnum::Enum`

Ruby 4.0 [reserves](https://bugs.ruby-lang.org/issues/20884) the top-level `Ruby` module for the language itself, so this gem's `Ruby::Enum` namespace is no longer safe to use. As of `2.0.0`, the gem uses `RubyEnum::Enum` instead.

`gem 'ruby-enum', '< 2.0.0'`

``` ruby
class Color
  include Ruby::Enum

  define :RED, 'red'
end
```

`gem 'ruby-enum', '>= 2.0.0'`

``` ruby
class Color
  include RubyEnum::Enum

  define :RED, 'red'
end
```

For backward compatibility, `Ruby::Enum` is still available as a deprecated alias for `RubyEnum::Enum` and will emit a deprecation warning when included. It will be removed in a future major version. Update your code to use `RubyEnum::Enum` and `RubyEnum::Enum::Case` directly.

See [#55](https://github.com/dblock/ruby-enum/issues/55) for more information.

## Upgrading to >= 0.9.0

### Inheritance & `RubyEnum::Enum.values`

This only applies to classes that inherit from another which is a `RubyEnum::Enum`.

Prior to version `0.9.0`, the `values` class method would enumerate only the
values defined in the class.

As of version `0.9.0`, the `values` class method enumerates values defined in
the entire class heirarchy, ancestors first.

``` ruby
class PrimaryColors
  include RubyEnum::Enum

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

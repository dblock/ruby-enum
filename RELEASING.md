# Releasing Ruby-Enum

There are no hard rules about when to release ruby-enum. Release bug fixes frequently, features not so frequently and breaking API changes rarely.

### Release

Run tests, check that all tests succeed locally.

```
bundle install
rake
```

Check that the last build succeeded in [GitHub Actions](https://github.com/dblock/ruby-enum/actions) for all supported platforms.

Add a date to this release in [CHANGELOG.md](CHANGELOG.md).

```
### 0.2.2 (2015/7/10)
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Commit your changes.

```
git add README.md CHANGELOG.md lib/ruby-enum/version.rb
git commit -m "Preparing for release, 0.2.2."
```

Release. If you have MFA enabled on RubyGems (you should), `rake release` will build the gem, tag it, and push commits/tags to GitHub, but fail at the RubyGems push. Push the gem manually with your OTP.

```
$ rake release

ruby-enum 1.1.0 built to pkg/ruby-enum-1.1.0.gem.
Tagged v1.1.0.
Pushed git commits and tags.
...
You have enabled multi-factor authentication. Please enter OTP code.
```

Then push to RubyGems manually:

```
$ gem push pkg/ruby-enum-1.1.0.gem --otp <OTP>
Pushing gem to https://rubygems.org...
Successfully registered gem: ruby-enum (1.1.0)
```

### Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```
### 0.2.3 (Next)

* Your contribution here.
```

Increment the third version number in [lib/ruby-enum/version.rb](lib/ruby-enum/version.rb).

Commit your changes.

```
git add CHANGELOG.md lib/ruby-enum/version.rb
git commit -m "Preparing for next development iteration, 0.2.3."
git push origin master
```

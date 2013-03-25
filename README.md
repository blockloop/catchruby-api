# Catch Notes Ruby API

[Catch Notes](http://catch.com) is a free app for capturing ideas and turning them into action with simple mobile collaboration.

They have wrapper libraries for [Android][], [PHP][], [Obj-C][], and [Python][] so I decided to write one for Ruby.

# Usage

```ruby
require 'catch'

# Authenticate the application
Catch.authenticate username,password

# Grab all streams (or Spaces)
streams = Catch::Stream.all
space = streams.first

# Get a note
note = space.notes.first

# Search for a note within a stream
result = stream.search "foo" # => array of Note
```

  [Android]: https://github.com/catch/android-api
  [PHP]: https://github.com/catch/php-api
  [Obj-C]: https://github.com/catch/objc-api
  [Python]: https://github.com/catch/python-api

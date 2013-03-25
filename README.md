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
barenote = space.notes.first (will get you the notes details without the text)
note = space.notes.first.full (gets the full note with the text)
```

  [Android]: https://github.com/catch/android-api
  [PHP]: https://github.com/catch/php-api
  [Obj-C]: https://github.com/catch/objc-api
  [Python]: https://github.com/catch/python-api

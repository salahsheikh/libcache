# Libcache [![Build Status](https://travis-ci.org/silk8192/libcache.svg?branch=master)](https://travis-ci.org/silk8192/libcache) [![Gem Version](https://badge.fury.io/rb/libcache.svg)](https://badge.fury.io/rb/libcache)

A simple caching library that provides flexible and powerful caching features such as in-memory and file based caching similar to Guava's Caching system.

## Features

* Supports in-memory cache
* Supports filesystem based cache
* Limiting the size of the cache through eviction based on a specified max size
* Allows for expiration behavior based on the time since an object was placed in the cache or when it was last accessed/updated
* Allows custom refresh functions for reloading expensive data once it has been discarded 



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'libcache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install libcache

## Usage

For an in memory Cache with an expiry time of 3 seconds, store location at 'foo\bar', a max size of 500, and refresh method where 100 is added to the key (of course more sophisticated value retrieving operations will replace this method). Of course these additions are optional and configurable. The simplest form of an in-memory cache is ```CacheBuilder.with(Cache).build```
```ruby

cache = CacheBuilder.with(Cache).set_expiry('3s').set_max(500).set_refresh(Proc.new { |key| key + 100 }).build

cache.put(1, 5)
cache.get(1) # will return 5
sleep 4 # note that this is more than the expiry time
cache.get(1) # will return 105 as the data has been refreshed
cache.exists?(1) # will return true. if there is no set_refresh method provided then it will return false

# delete all data on exit of program
at_exit do
  cache.invalidateAll
end

```

For an file-based Cache with an expiry time of 3 seconds, store location at 'foo\bar', and refresh method where 100 is added to the key (of course more sophisticated value retrieving operations will replace this method). Of course these additions are optional and configurable. The only thing that is non-removable is the ```set_store``` method. 
```ruby
cache = CacheBuilder.with(FileCache).set_store('foo\bar').set_expiry('3s').set_expiry('3s').set_max(500).set_refresh(Proc.new { |key| key + 100 }).build

cache.put(1, 5)
cache.get(1) # will return 5
sleep 4 # note that this is more than the expiry time
cache.get(1) # will return 105 as the data has been refreshed
cache.exists?(1) # will return true. if there is no set_refresh method provided then it will return false


# delete all leftover files on exit of program
at_exit do
  cache.invalidateAll
end
```

For more on what kind of strings are understood as times, [click here](https://github.com/jmettraux/rufus-scheduler/blob/two/README.rdoc#the-time-strings-understood-by-rufus-scheduler).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/silk8192/libcache. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


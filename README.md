# Libcache [![Build Status](https://travis-ci.org/silk8192/libcache.svg?branch=master)](https://travis-ci.org/silk8192/libcache) [![Gem Version](https://badge.fury.io/rb/libcache.svg)](https://badge.fury.io/rb/libcache)

A simple caching library that provides flexible and powerful caching features such as in-memory and file based caching similar to Guava's Caching system. [Docs.](http://www.rubydoc.info/gems/libcache)

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
For an in memory Cache with an expiry time of 3 seconds, a max size of 500, and refresh method where 100 is added to the key (of course more sophisticated value retrieving operations will replace this method), and a function set_post_get which defines a function to be executed after the retrieval of a key. The These additions are optional and configurable. The simplest form of an in-memory cache is 'CacheBuilder.with(Cache).build'
```ruby
cache = CacheBuilder.with(Cache).set_expiry('3s').set_max(500).set_refresh(lambda { |key| key + 100 }).set_post_get(lambda { |*key| puts "Retrieved #{key}!" }).build
```
...or for an file-based Cache with an expiry time of 3 seconds, store location at 'foo\bar', and refresh method where 100 is added to the key, and a function set_post_get which defines a function to be executed after the retrieval of a key. Of course these additions are optional and configurable. The only thing that is non-removable is the ```set_store``` method. The simplest form of a File cache is 'CacheBuilder.with(FileCache).set_store('foo\bar').build'
```ruby
cache = CacheBuilder.with(FileCache).set_store('foo\bar').set_expiry('3s').set_max(500).set_refresh(lambda { |key| key + 100 }).set_post_get(lambda { |*key| puts "Retrieved #{key}!" }).build
```
```ruby
cache.put(1, 5)
cache.get(1) # will return 5, also prints "Retrieved [1]!" to the console, as per the function defined in the set_post_get method
sleep 4 # note that this is more than the expiry time
cache.get(1) # will return 105 as the data has been refreshed, also prints "Retrieved [1]!" 
cache.exists?(1) # will return true. if there is no set_refresh method provided then it will return false

cache.put("key123", [1,2,true])
pp cache.get("key123") # prints '[1, 2, true]' preserves type, prints "Retrieved ["key123"]!"

# delete all data on exit of program
# if the file cache was used, deletes all left over files. #cache.invalidate_all can be called at any point in runtime.
at_exit do
  cache.invalidate_all
end

```
For more on what kind of strings are understood as times, like "3s", [click here](https://github.com/jmettraux/rufus-scheduler/blob/two/README.rdoc#the-time-strings-understood-by-rufus-scheduler).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/silk8192/libcache. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


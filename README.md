# Libcache

A caching library that provides in-memory and file based cache

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

For an in memory Cache with an expiry time of 3 seconds
```ruby

cache = CacheBuilder.with(Cache).set_expiry('3s').set_refresh(Proc.new { |key| key + 100 }).build

cache.put(1, 5)

cache.get(1) # will return 5

sleep 4 # note that this is more than the expiry time

cache.get(1) # will return 105 as the data has been refreshed

# delete all data on exit of program
at_exit do
  cache.invalidateAll
end

```

For an file-based Cache with an expiry time of 3 seconds and store locationi at 'foo\bar'
```ruby
cache = CacheBuilder.with(FileCache).set_store('foo\bar').set_expiry('3s').set_refresh(Proc.new { |key| key + 100 }).build

cache.put(1, 5)
cache.get(1) # will return 5
sleep 4 # note that this is more than the expiry time
cache.get(1) # will return 105 as the data has been refreshed

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


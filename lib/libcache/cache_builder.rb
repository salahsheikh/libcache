require_relative 'cache'

class CacheBuilder

  # @param [Cache] cache Initializes with the type of Cache to be used
  def initialize(cache)
    @cache = cache.new
  end

  # @param [Cache] cache Sets the type of Cache to be used
  def self.with(cache)
    return self.new(cache)
  end

  # Sets the required file path for the FileCache
  # @param [String] path The path of the directory where cached files should be stored
  def set_store(path)
    @cache.store = path
    return self
  end

  # @param [String] time The time value after which an object should expire in the cache. Can be written as '2s' for two seconds, for example. For more info see: https://github.com/jmettraux/rufus-scheduler/blob/two/README.rdoc#the-time-strings-understood-by-rufus-scheduler
  def set_expiry(time)
    @cache.expiry_time = time
    return self
  end

  # Sets the refresh method required for recalling new objects after expiration
  # @param [Proc] proc The refresh method as a Proc object
  def set_refresh(proc)
    @cache.refresh = proc
    return self
  end

  # Sets the optional max size of a cache
  # @param [Integer] max_size The max size of the cache
  def set_max(max_size)
    @cache.max_size = max_size
    return self
  end

  def set_post_get(proc)
    @cache.post_get = proc
    return self
  end

  # Returns the newly created cache
  def build
    @cache.create_store
    return @cache.dup
  end

end
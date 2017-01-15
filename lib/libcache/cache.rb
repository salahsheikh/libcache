require 'rufus-scheduler'
require 'pp'

class Cache

  attr_accessor :expiry_time, :refresh, :store, :max_size

  # Creates a basic Cache with the UTC timezone
  def initialize
    ENV['TZ'] = 'UTC'
    @scheduler = Rufus::Scheduler.new
    @time_tracker = Hash.new
  end

  # Initializes the cache store
  def create_store
    @cache = Hash.new
  end

  # Places an object inside the cache and handles max size eviction
  # @param [String] key The key value used to identify an object in the cache
  # @param [Object] value The object to be placed in the cache
  def put(key, value)
    # removed oldest entry if max_size is approached
    if max_size != nil
      if @cache.size >= max_size
        key, value = @time_tracker.values.sort {|v| Time.now - v }.reverse.first
        invalidate(key)
        @time_tracker.delete(key)
      end
      @time_tracker[key] = Time.now
    end
    @cache[key] = value
    @scheduler.in expiry_time, :blocking => true do
      invalidate key
    end
  end

  # Gets the object that corresponds with the key
  # @param [String] key The key value used to identify an object in the cache
  # @return [Object] The object that corresponds with the key
  def get(key)
    check_refresh(key)
    return @cache[key]
  end

  # Checks if a key-value pair exists in the cache
  # @param [String] key The key value used to identify an object in the cache
  # @return [Boolean] The existence of the key in the cache
  def exists?(key)
    return @cache.key?(key)
  end

  # Refreshes an object if it has been invalidated
  # @param [String] key The key value used to identify an object in the cache
  # @return [Object] The refreshed object that is recalled from the refresh method
  def check_refresh(key)
    if @cache[key] == nil && !has_refresh?
      val = refresh.call(key)
      put(key, val)
      return val
    end
  end

  # @return [Boolean] Checks if the cache has a refresh method
  def has_refresh?
    return refresh == nil
  end

  # Deletes a key-value pair from the cache
  # @param [String] key The key value used to identify an object in the cache
  def invalidate(key)
    @cache.delete key
  end

  # Clears all items in the cache
  def invalidateAll
    @cache.clear
  end

end

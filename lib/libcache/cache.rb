require 'rufus-scheduler'
require 'pp'

class Cache

  attr_accessor :expiry_time, :refresh, :store, :max_size, :post_get

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
    @cache[key] = value
    if expiry_time != nil
      @scheduler.in expiry_time, :blocking => true do
        invalidate key
      end
    end
    check_expiration(key)
  end

  private def check_expiration(key)
    # removed oldest entry if max_size is approached
    @time_tracker[key] = Time.now
    if max_size != nil
      if get_size >= max_size
        n = get_size - max_size
        keys = @time_tracker.sort_by{|k,v| Time.now - v }.reverse.first n
        keys.each do |keyz, valuez|
          invalidate(keyz)
          @time_tracker.delete(keyz)
        end
      end
    end
  end

  # Gets the object that corresponds with the key
  # @param [String] key The key value used to identify an object in the cache
  # @return [Object] The object that corresponds with the key
  def get(key)
    check_refresh(key)
    if(@cache[key]) == nil
      return nil
    end
    perform_post_get(key)
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

  # Performs a function after a key has been summoned from the cache
  # @param [String] key The key value used to identify an object in the cache
  def perform_post_get(key)
    unless post_get.nil?
      post_get.call(key)
    end
  end

  # @return [Boolean] Checks if the cache has a refresh method
  def has_refresh?
    return refresh == nil
  end

  def get_size
    return @cache.length
  end

  # Deletes a key-value pair from the cache
  # @param [String] key The key value used to identify an object in the cache
  def invalidate(key)
    @cache.delete key
  end

  # Clears all items in the cache
  def invalidate_all
    @cache.clear
  end

end

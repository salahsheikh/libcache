require 'rufus-scheduler'

class Cache

  attr_accessor :expiry_time, :refresh, :store, :max_size

  def initialize
    ENV['TZ'] = 'UTC'
    @scheduler = Rufus::Scheduler.new
  end

  def create_store
    @cache = Hash.new
  end

  def put(key, value)
    @cache[key] = value
    @scheduler.in expiry_time, :blocking => true do
      invalidate key
    end
  end

  def get(key)
    refresh
    return @cache[key]
  end

  def exists?(key)
    return @cache.key?(key)
  end

  def invalidate(key)
    @cache.delete key
  end

  def invalidateAll
    @cache.clear
  end

  def refresh
    if @cache[key] == nil && !has_refresh?
      val = refresh.call(key)
      put(key, val)
      return val
    end
  end

  def has_refresh?
    return refresh == nil
  end

end
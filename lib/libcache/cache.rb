require 'rufus-scheduler'
require 'pp'

class Cache

  attr_accessor :expiry_time, :refresh, :store, :max_size

  def initialize
    ENV['TZ'] = 'UTC'
    @scheduler = Rufus::Scheduler.new
    @time_tracker = Hash.new
  end

  def create_store
    @cache = Hash.new
  end

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

  def get(key)
    check_refresh(key)
    return @cache[key]
  end

  def exists?(key)
    return @cache.key?(key)
  end


  def check_refresh(key)
    if @cache[key] == nil && !has_refresh?
      val = refresh.call(key)
      put(key, val)
      return val
    end
  end

  def has_refresh?
    return refresh == nil
  end

  def invalidate(key)
    @cache.delete key
  end

  def invalidateAll
    @cache.clear
  end

end

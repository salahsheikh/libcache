require 'rufus-scheduler'

class Cache

  attr_accessor :expiry_time, :refresh, :store

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
    if @cache[key] == nil
      return refresh.call key
    end
    return @cache[key]
  end

  def invalidate(key)
    @cache.delete key
  end

  def invalidateAll
    @cache.clear
  end

end
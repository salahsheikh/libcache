require_relative 'cache'

class CacheBuilder

  def initialize(cache)
    @cache = cache.new
  end

  def self.with(cache)
    return self.new(cache)
  end

  def set_store(path)
    @cache.store = path
    return self
  end

  def set_expiry(time)
    @cache.expiry_time = time
    return self
  end

  def set_refresh(proc)
    @cache.refresh = proc
    return self
  end

  def set_max(max_size)
    @cache.max_size = max_size
  end

  def build
    @cache.create_store
    return @cache.dup
  end

end
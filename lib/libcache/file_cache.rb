require_relative 'cache'

class FileCache < Cache

  def initialize
    super
  end

  def create_store
    @cache = Hash.new
    if store == nil
      raise 'Store path is missing!'
    end
  end

  def put(key, value)
    @cache[key] = value
    File.open(File.join(store, key.to_s), 'w') do |f|
      f.write(value)
    end
    @scheduler.in expiry_time, :blocking => true do
      invalidate key
    end
  end

  def get(key)
    if @cache[key] == nil
      val = refresh.call(key)
      put(key, val)
      return val
    end
    return File.read(File.join(store, key.to_s))
  end

  def invalidate(key)
    super
    File.delete(File.join(store, key.to_s))
  end

  def invalidateAll
    super
    Dir.foreach(store) { |f|
      File.delete(File.join(store, f)) if f != '.' && f != '..'
    }
  end

end
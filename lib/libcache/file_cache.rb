require 'digest'

require_relative 'cache'

class FileCache < Cache

  def initialize
    super
  end

  # Initializes the cache store along with the keys store. Raises an exception if the store path is not supplied.
  def create_store
    @cache = Hash.new
    @keys = Hash.new
    if store == nil
      raise 'Store path is missing!'
    end
  end

  # Places an object inside the cache, and by extension, into the filesystem. Handles max size eviction. Raises an InvalidKey exception if the key is not formatted properly.
  # @param [String] key The key value used to identify an object in the cache
  # @param [Object] value The object to be placed in the cache
  def put(key, value)
    raise InvalidKey unless key.is_a? String
    raise InvalidKey unless key =~ /\A[a-zA-Z0-9_-]+\z/
    if max_size != nil
      if @cache.size >= max_size - 1
        key, value = @time_tracker.values.sort {|v| Time.now - v }.reverse.first
        invalidate(key)
        @time_tracker.delete(key)
      end
      @time_tracker[key] = Time.now
    end
    @keys[key] = Digest::MD5.hexdigest(key) + Time.now.to_i.to_s
    @cache[key] = value
    File.open(File.join(store, @keys[key]), 'w') do |f|
      f.write(Marshal.dump(value))
    end
    @scheduler.in expiry_time, :blocking => true do
      invalidate key
    end
  end

  # Gets the object that corresponds with the key that is read from the filesystem
  # @param [String] key The key value used to identify an object in the cache
  # @return [Object] The object that corresponds with the key
  def get(key)
    refresh
    return Marshal.load(File.read(File.join(store, @keys[key])))
  end

  # Deletes a key-value pair from the cache and store directory
  # @param [String] key The key value used to identify an object in the cache
  def invalidate(key)
    super
    File.delete(File.join(store, @keys[key]))
    @keys.delete key
  end

  # Clears all items in the cache and the cached files in the store directory
  def invalidateAll
    super
    Dir.foreach(store) do |f|
      File.delete(File.join(store, f)) if f != '.' && f != '..'
    end
  end

end
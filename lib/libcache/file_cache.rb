require 'digest'

require_relative 'cache'

class FileCache < Cache

  def initialize
    super
  end

  def create_store
    @cache = Hash.new
    @keys = Hash.new
    if store == nil
      raise 'Store path is missing!'
    end
  end

  def put(key, value)
    if ((key =~ /\A[a-zA-Z0-9_-]+\z/) != 0) || !(key.instance_of? String)
      raise 'Invalid key value used!'
    end
    @keys[key] = Digest::MD5.hexdigest(key) + Time.now.to_i.to_s
    @cache[key] = value
    File.open(File.join(store, @keys[key]), 'w') do |f|
      f.write(value)
    end
    @scheduler.in expiry_time, :blocking => true do
      invalidate key
    end
  end

  def get(key)
    refresh
    return File.read(File.join(store, @keys[key]))
  end

  def invalidate(key)
    super
    File.delete(File.join(store, @keys[key]))
  end

  def invalidateAll
    super
    Dir.foreach(store) do |f|
      File.delete(File.join(store, f)) if f != '.' && f != '..'
    end
  end

end
require_relative 'test_helper'

class FileCacheTest < Minitest::Test

  def setup
    @key = "key"
    @value = "value"
    @store = File.join(File.dirname(__FILE__), "cache")
    Dir.mkdir(@store.to_s) unless File.exists?(@store.to_s)
  end

  def test_cache_insertion
    cache = CacheBuilder.with(FileCache).set_store(@store).build
    cache.put(@key, @value)
    assert(cache.exists?(@key))
  end

  def test_cache_eviction
    cache = CacheBuilder.with(FileCache).set_store(@store).build
    cache.put(@key, @value)
    cache.invalidate(@key)
    assert(!cache.exists?(@key))
  end

  def test_cache_returns
    cache = CacheBuilder.with(FileCache).set_store(@store).build
    cache.put(@key, @value)
    assert_equal(cache.get(@key), @value)
  end

  def test_cache_returntype
    cache = CacheBuilder.with(FileCache).set_store(@store).build
    test_data = [1,2,3]
    cache.put(@key, test_data)
    assert_equal(cache.get(@key), test_data)
  end

  def test_cache_max
    max = 5
    cache = CacheBuilder.with(FileCache).set_store(@store).set_max(max).build
    maxTest = 10
    maxTest.times do |index|
      cache.put(index.to_s, @value)
    end
    assert_equal(cache.get_size, max)
  end

  def test_cache_expiration
    expiration_time = "0.5s"
    cache = CacheBuilder.with(FileCache).set_store(@store).set_expiry(expiration_time).build
    cache.put(@key, @value)
    # sleeps for longer than expiration time
    sleep 1
    assert(!cache.exists?(@key))
  end

  def teardown
    FileUtils.rm_rf(@store)
  end

end
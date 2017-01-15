require_relative 'test_helper'

class MemcacheTest < Minitest::Test

  def setup
    @key = "key"
    @value = "value"
  end

  def test_cache_insertion
    cache = CacheBuilder.with(Cache).build
    cache.put(@key, @value)
    assert(cache.exists?(@key))
  end

  def test_cache_eviction
    cache = CacheBuilder.with(Cache).build
    cache.put(@key, @value)
    cache.invalidate(@key)
    assert(!cache.exists?(@key))
  end

  def test_cache_returns
    cache = CacheBuilder.with(Cache).build
    cache.put(@key, @value)
    assert_equal(cache.get(@key), @value)
  end

  def test_cache_max
    max = 5
    cache = CacheBuilder.with(Cache).set_max(max).build
    maxTest = 10
    maxTest.times do |index|
      cache.put(index, @value)
    end
    assert_equal(cache.get_size, max)
  end

  def test_cache_expiration
    expiration_time = "3s"
    cache = CacheBuilder.with(Cache).set_expiry(expiration_time).build
    cache.put(@key, @value)
    # sleeps for longer than expiration time
    sleep 4
    assert(!cache.exists?(@key))
  end

end
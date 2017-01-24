require_relative 'test_helper'

class MemcacheTest < Minitest::Test

  parallelize_me!

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

  def test_cache_returntype
    cache = CacheBuilder.with(Cache).build
    testData = [1,2,3]
    cache.put(@key, testData)
    assert_equal(cache.get(@key).class, testData.class)
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
    expiration_time = "1s"
    cache = CacheBuilder.with(Cache).set_expiry(expiration_time).build
    cache.put(@key, @value)
    # sleeps for longer than expiration time
    sleep 2
    assert(!cache.exists?(@key))
  end

  def test_cache_post_get
    val = 0
    cache = CacheBuilder.with(Cache).set_post_get(lambda { |*key| val = 1}).build
    cache.put(@key, @value)
    cache.get(@key)
    assert_equal(1, val)
  end

end

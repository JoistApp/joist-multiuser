# frozen_string_literal: true

class Cacheable::Etag::Storage
  def self.delete(key)
    Rails.cache.delete key
  end

  def self.read(key)
    Rails.cache.read key
  end

  def self.fetch(key, &block)
    if block
      Rails.cache.fetch(key) { block.call }
    else
      Rails.cache.fetch(key)
    end
  end

  def self.write(key, value)
    Rails.cache.write key, value
  end
end

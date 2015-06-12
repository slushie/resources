module Resources
  class Pool
    attr_reader :name
    attr_reader :dlm
    attr_reader :redis

    def initialize(options)
      @redis = options.fetch(:redis)
      @dlm = Redlock::Client.new([redis])
      @name = options.fetch(:name, 'resources')
    end

    def clear
      redis.del(pool_key, values_key)
      redis.del(*redis.keys(item_lock_key '*'))
    end

    def push(key, value)
      dlm.lock(item_lock_key(key), 1000) do |locked|
        if locked
          if redis.sadd(pool_key, key) == 1
            redis.hset(values_key, key, value)
          end
        end
      end
    end

    def acquire(duration)
      key = redis.srandmember(pool_key).first
      return unless key

      lock_info = dlm.lock(item_lock_key(key), duration)
      return unless lock_info

      value = redis.hget(values_key, key)
      Lock.new(lock_info, key, value)
    end

    def update(lock, value)
      raise "Lock expired" if lock.expired?
      redis.hset(values_key, lock.key, lock.value = value)
    end

    def release(lock)
      dlm.unlock(lock.info)
    end

    protected

    def pool_key
      @pool_key ||= ['resources:pool', name] * ':'
    end

    def values_key
      @values_key ||= ['resources:pool', name, 'values'] * ':'
    end

    def item_lock_key(item)
      ['resources:pool', name, 'items', item] * ':'
    end
  end
end
module Resources
  class Lock
    attr_reader :info
    attr_reader :expiration
    attr_reader :key, :value

    def initialize(info, key, value)
      @key = key
      @value = value
      @info = info

      @expiration = Time.now + (validity.to_f / 1000.0)
    end

    def validity
      info[:validity]
    end

    def lock_key
      info[:resource]
    end

    def expired?
      expiration < Time.now
    end
  end
end
module Resources
  class Lock
    attr_reader :info
    attr_reader :expiration
    attr_reader :resource

    def initialize(info, resource)
      @info = info
      @expiration = Time.now + (validity.to_f / 1000.0)
      @resource = resource
    end

    def validity
      info[:validity]
    end

    def resource_key
      info[:resource]
    end

    def expired?
      expiration < Time.now
    end
  end
end
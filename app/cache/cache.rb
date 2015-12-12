# Even though the current implementation uses Redis to enable cache function,
# we can easily change the actual implementation by using this interface.
class Cache

  class << self

    def data
      @data ||= Redis.new
    end

    # @example
    #
    #  Cache.set('name', 'jane doe')
    #
    #  # expire after 30 seconds
    #  Cache.set('name', 'jane doe', expire_after: 30)
    #
    #  # expire at tomorrow
    #  Cache.set('name', 'jane doe', expire_at: DateTime.tomorrow.beginning_of_day.to_i)
    #
    def set(key, value, options = {})
      res = data.set(key, value)
      if options[:expire_after]
        expire_after(key, options[:expire_after])
      elsif options[:expire_at]
        expire_at(key, options[:expire_at])
      end
      res
    end

    #
    # [get description]
    # @param key [type] [description]
    #
    # @return [type] [description]
    def get(key)
      data.get(key)
    end

    def get_or_set_if_not_existed(key, options = {}, &proc)
      val = get(key)
      if val.nil?
        val = proc.call
        set(key, val, options)
      end
      val
    end

    def del(*argv)
      data.del(*argv)
    end

    private

      # expire the key after the given seconds
      def expire_after(key, seconds)
        data.expire(key, seconds)
      end

      def expire_at(key, timestamp)
        data.expire(key, [0, timestamp-Time.now.to_i].max)
      end


      def set_namespace(namespace)
        @namespace = namespace
      end

  end
end

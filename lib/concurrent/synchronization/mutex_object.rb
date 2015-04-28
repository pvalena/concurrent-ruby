module Concurrent
  module Synchronization
    class MutexObject < AbstractObject
      def initialize(*args, &block)
        @__lock__do_not_use_directly      = ::Mutex.new
        @__condition__do_not_use_directly = ::ConditionVariable.new
        synchronize { ns_initialize(*args, &block) }
      end

      private

      def synchronize
        if @__lock__do_not_use_directly.owned?
          yield
        else
          @__lock__do_not_use_directly.synchronize { yield }
        end
      end

      def ns_signal
        @__condition__do_not_use_directly.signal
        self
      end

      def ns_broadcast
        @__condition__do_not_use_directly.broadcast
        self
      end

      def ns_wait(timeout = nil)
        @__condition__do_not_use_directly.wait @__lock__do_not_use_directly, timeout
        self
      end
    end
  end
end

module ShellMock
  class CallVerifier
    def initialize
      match_calls_when { |calls| calls.any? }
    end

    def times(n)
      match_calls_when { |calls| calls.size == n }

      self
    end

    def fewer_than(n)
      match_calls_when { |calls| calls.size < n }

      self
    end
    alias less_than fewer_than

    def more_than(n)
      match_calls_when { |calls| calls.size > n }

      self
    end

    def once
      times(1)
    end

    def never
      times(0)
    end

    def matches?(actual)
      @actual = actual

      condition.call(actual.calls)
    end

    def failure_message
      "#{actual.command} was expected."
    end

    def failure_message_when_negated
      "#{actual.command} was not expected."
    end

    private

    attr_reader :actual, :condition

    def match_calls_when(&blk)
      @condition = blk
    end
  end
end

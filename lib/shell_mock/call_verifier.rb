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

    def matches?(command_stub)
      @command_stub = command_stub

      condition.call(command_stub.calls)
    end

    def failure_message
      "#{command_stub.command} was expected."
    end

    def failure_message_when_negated
      "#{command_stub.command} was not expected."
    end

    private

    attr_reader :command_stub, :condition

    def match_calls_when(&blk)
      @condition = blk
    end
  end
end

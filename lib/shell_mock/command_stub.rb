module ShellMock
  class CommandStub
    attr_reader :command, :expected_output, :return_code

    def initialize(command)
      @command = command
    end

    def with_env(env)
      @env = env

      self
    end

    def env
      @env || {}
    end

    def with_option(option)
      @options = options

      self
    end

    def options
      @options || {}
    end

    def and_return(expected_output, return_code: 0)
      @expected_output = expected_output
      @return_code     = return_code

      self
    end

    def matches?(command)
      !!/#{self.command}/.match(command)
    end

    def side_effect
      @side_effect || proc {}
    end

    def calls
      @calls ||= []
    end

    def has_been_called?
      calls.any?
    end

    def called_with(env, command, options)
      calls << [env, command, options]
    end
  end
end

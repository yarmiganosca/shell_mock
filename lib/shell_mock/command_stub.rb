require 'shell_mock/stub_registry'
require 'shell_mock/core_ext/module'

module ShellMock
  class CommandStub
    attr_reader :command, :output, :exitstatus, :env, :options, :side_effect

    def initialize(command)
      @command     = command
      @side_effect = proc {}

      @reader, @writer = IO.pipe

      with_env({})
      with_options({})
      to_output(nil)
      to_succeed
    end

    def with_env(env)
      @env = env

      self
    end

    def with_options(options)
      @options = options

      self
    end

    def to_output(output)
      @output = output

      self
    end
    alias and_output to_output
    deprecate :and_output, :to_output, "1.0.0"

    def to_return(output)
      self.
        to_output(output).
        to_exit(0)
    end
    alias and_return to_return
    deprecate :and_return, :to_return, "1.0.0"

    def to_exit(exitstatus)
      @exitstatus = exitstatus

      self
    end
    alias and_exit to_exit
    deprecate :and_exit, :to_exit, "1.0.0"

    def to_succeed
      to_exit(0)
    end
    alias and_succeed to_succeed
    deprecate :and_succeed, :to_succeed, "1.0.0"

    def to_fail
      to_exit(1)
    end
    alias and_fail to_fail
    deprecate :and_fail, :to_fail, "1.0.0"

    def runs
      @runs ||= 0

      loop do
        begin
          reader.read_nonblock(1)
          @runs += 1
        rescue IO::WaitReadable
          break
        end
      end

      @runs
    end

    def ran
      writer.write("R")
    end

    def to_oneliner
      if output
        "echo '#{output}' && exit #{exitstatus}"
      else
        "exit #{exitstatus}"
      end
    end

    private

    attr_reader :reader, :writer
  end
end

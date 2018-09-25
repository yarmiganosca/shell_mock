require 'shell_mock/stub_registry'

module ShellMock
  class CommandStub
    attr_reader :command, :output, :exitstatus, :env, :options, :side_effect

    def initialize(command)
      @command     = command
      @env         = {}
      @options     = {}
      @side_effect = proc {}
      @exitstatus  = 0
      @output      = nil

      @reader, @writer = IO.pipe
    end

    def with_env(env)
      @env = env

      self
    end

    def with_options(options)
      @options = options

      self
    end

    def and_output(output)
      @output = output

      self
    end

    def and_return(output)
      self.
        and_output(output).
        and_exit(0)
    end

    def and_exit(exitstatus)
      @exitstatus = exitstatus

      self
    end

    def calls
      @calls ||= 0

      marshaled_signatures.each do |marshaled_signature|
        @calls += 1
      end

      @calls
    end

    def called
      writer.puts("called\n")
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

    def marshaled_signatures
      messages = ""

      loop do
        begin
          messages += reader.read_nonblock(1)
        rescue IO::WaitReadable
          break
        end
      end

      messages.split("\n")
    end
  end
end

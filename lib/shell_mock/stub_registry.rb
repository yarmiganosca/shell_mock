module ShellMock
  StubRegistry = Object.new

  StubRegistry.instance_exec do
    def register_command_stub(command_stub)
      command_stubs << command_stub
      command_stub
    end

    def stub_matching(env, command, options)
      matching_stubs = command_stubs.select do |command_stub|
        command_stub.env <= env &&
          command_stub.options <= options &&
          command_stub.command == command
      end

      # question: should we increment all the stubs that match?
      matching_stubs.max_by do |command_stub|
        [env.size, options.size]
      end
    end

    def command_stubs
      @command_stubs ||= []
    end

    def clear
      @command_stubs = []
    end
  end
end

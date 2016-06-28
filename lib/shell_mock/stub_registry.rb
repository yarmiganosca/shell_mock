module ShellMock
  StubRegistry = Object.new

  StubRegistry.instance_exec do
    def register_command_stub(command_stub)
      command_stubs.insert(0, command_stub)

      command_stub
    end

    def stub_matching(env, command, options)
      command_stubs.find do |command_stub|
        command_stub.env <= env &&
          command_stub.matches?(command) &&
          command_stub.options <= options
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

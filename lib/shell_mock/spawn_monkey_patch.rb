require 'shell_mock/monkey_patch'
require 'shell_mock/stub_registry'
require 'shell_mock/no_stub_specified'
require 'shell_mock/spawn_arguments'

module ShellMock
  class SpawnMonkeyPatch < MonkeyPatch
    def method_name
      :spawn
    end

    def override(*args)
      env, command, options = SpawnArguments(*args)

      stub = StubRegistry.stub_matching(env, command, options)

      if stub
        stub.ran

        stub.side_effect.call

        __un_shell_mocked_spawn(stub.to_oneliner, options)
      else
        if ShellMock.let_commands_run?
          __un_shell_mocked_spawn(env, command, options)
        else
          raise NoStubSpecified.new(command)
        end
      end
    end

    def enable
      enable_for(Process.eigenclass) unless Process.respond_to?(method_alias, true)

      super
    end

    def disable
      super

      disable_for(Process.eigenclass) if Process.respond_to?(method_alias, true)
    end
  end
end

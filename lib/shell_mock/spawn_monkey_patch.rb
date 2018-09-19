require 'shell_mock/monkey_patch'
require 'shell_mock/stub_registry'
require 'shell_mock/no_stub_specified'

module ShellMock
  class SpawnMonkeyPatch < MonkeyPatch
    def method_name
      :spawn
    end

    def override(env, command = nil, **options)
      env, command = {}, env if command.nil?

      # other arg manipulation can go here if necessary

      stub = StubRegistry.stub_matching(env, command, options)

      if stub
        stub.called_with(env, command, options)

        stub.side_effect.call

        __un_shell_mocked_spawn("exit #{stub.exitstatus}")
      else
        if ShellMock.let_commands_run?
          __un_shell_mocked_spawn(env, command, **options)
        else
          raise NoStubSpecified.new(env, command, options)
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

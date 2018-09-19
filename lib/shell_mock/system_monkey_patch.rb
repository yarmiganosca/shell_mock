require 'shell_mock/monkey_patch'
require 'shell_mock/stub_registry'
require 'shell_mock/no_stub_specified'

module ShellMock
  class SystemMonkeyPatch < MonkeyPatch
    def method_name
      :system
    end

    def override(env, command = nil, **options)
      env, command = {}, env if command.nil?

      # other arg manipulation can go here if necessary

      stub = StubRegistry.stub_matching(env, command, options)

      if stub
        stub.called_with(env, command, options)

        stub.side_effect.call
        __un_shell_mocked_backtick("exit #{stub.exitstatus}")

        return stub.exitstatus == 0
      else
        if ShellMock.let_commands_run?
          __un_shell_mocked_system(env, command, **options)
        else
          raise NoStubSpecified.new(env, command, options)
        end
      end
    end
  end
end
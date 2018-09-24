require 'shell_mock/monkey_patch'
require 'shell_mock/stub_registry'
require 'shell_mock/no_stub_specified'

module ShellMock
  class BacktickMonkeyPatch < MonkeyPatch
    def method_name
      "`"
    end

    def interpolatable_name
      :backtick
    end

    def override(command)
      stub = StubRegistry.stub_matching({}, command, {})

      if stub
        stub.called_with({}, command, {})

        stub.side_effect.call

        __un_shell_mocked_backtick(stub.to_oneliner)
      else
        if ShellMock.let_commands_run?
          __un_shell_mocked_backtick(command)
        else
          raise NoStubSpecified.new({}, command, {})
        end
      end
    end
  end
end

require "shell_mock/version"
require 'shell_mock/stub_registry'
require 'shell_mock/command_stub'
require 'shell_mock/core_ext/kernel'

module ShellMock
  def self.stub_command(command)
    command_stub = CommandStub.new(command)

    StubRegistry.register_command_stub(command_stub)
  end

  def self.let_commands_run
    @let_commands_run = true
  end

  def self.dont_let_commands_run
    @let_commands_run = false
  end

  def self.let_commands_run?
    @let_commands_run.nil? ? true : @let_commands_run
  end

  def self.dont_let_commands_run?
    !let_commands_run?
  end

  def self.enable
    Kernel.module_exec do
      if !!Kernel.method(:__shell_mocked_system)
        alias __un_shell_mocked_system system
        alias system __shell_mocked_system
      end

      if !!Kernel.method(:__shell_mocked_backtick)
        alias_method(:__un_shell_mocked_backtick, :`)
        alias_method(:`, :__shell_mocked_backtick)
      end
    end
  end

  def self.disable
    Kernel.module_exec do
      alias_method(:system, :__un_shell_mocked_system) if Kernel.respond_to?(:__un_shell_mocked_system)
      alias_method(:`, :__un_shell_mocked_backtick)    if Kernel.respond_to?(:__un_shell_mocked_backtick)
    end

    StubRegistry.clear
  end
end

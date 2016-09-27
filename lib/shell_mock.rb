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
    @let_commands_run = true if @let_commands_run.nil?
    @let_commands_run
  end

  def self.dont_let_commands_run?
    !let_commands_run?
  end

  def self.enable
    Kernel.module_exec do
      if Kernel.respond_to?(:__shell_mocked_system)
        define_method(:__un_shell_mocked_system, &method(:system).to_proc)
        define_method(:system, &method(:__shell_mocked_system).to_proc)
      end

      if Kernel.respond_to?(:__shell_mocked_backtick)
        define_method(:__un_shell_mocked_backtick, &method(:`).to_proc)
        define_method(:`, &method(:__shell_mocked_backtick).to_proc)
      end
    end
  end

  def self.disable
    Kernel.module_exec do
      define_method(:system, &method(:__un_shell_mocked_system).to_proc) if Kernel.respond_to?(:__un_shell_mocked_system)
      define_method(:`, &method(:__un_shell_mocked_backtick).to_proc)    if Kernel.respond_to?(:__un_shell_mocked_backtick)
    end

    StubRegistry.clear
  end
end

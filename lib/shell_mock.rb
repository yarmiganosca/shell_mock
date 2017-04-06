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
      [
        [:system, :__un_shell_mocked_system,   :__shell_mocked_system],
        [:`,      :__un_shell_mocked_backtick, :__shell_mocked_backtick],
      ].each do |real_name, aliased_name, replacement_name|
        if respond_to?(replacement_name)
          define_method(aliased_name, &method(real_name).to_proc)
          define_method(real_name,    &method(replacement_name).to_proc)
        end
      end
    end
  end

  def self.disable
    Kernel.module_exec do
      [
        [:system, :__un_shell_mocked_system],
        [:`,      :__un_shell_mocked_backtick],
      ].each do |real_name, aliased_name|
        define_method(real_name, &method(aliased_name).to_proc) if respond_to?(aliased_name)
      end
    end

    StubRegistry.clear
  end
end

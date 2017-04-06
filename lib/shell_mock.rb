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
      ShellMock.alias_specifications.each do |spec|
        if respond_to?(spec.replacement)
          define_method(spec.alias_for_original, &method(spec.original).to_proc)
          define_method(spec.original,           &method(spec.replacement).to_proc)
        end
      end
    end
  end

  def self.disable
    Kernel.module_exec do
      ShellMock.alias_specifications.each do |spec|
        if respond_to?(spec.alias_for_original)
          define_method(spec.original, &method(spec.alias_for_original).to_proc)
        end
      end
    end

    StubRegistry.clear
  end

  AliasSpecification = Struct.new(:original, :alias_for_original, :replacement)

  def self.alias_specifications
    [
      AliasSpecification.new(:system, :__un_shell_mocked_system,   :__shell_mocked_system),
      AliasSpecification.new(:exec,   :__un_shell_mocked_exec,     :__shell_mocked_exec),
      AliasSpecification.new(:`,      :__un_shell_mocked_backtick, :__shell_mocked_backtick),
    ]
  end
end

require 'shell_mock/no_stub_specified'

module ShellMock
  class MonkeyPatch
    def enable
      enable_for(Kernel.singleton_class) unless Kernel.respond_to?(method_alias, true)
      enable_for(Kernel)                 unless Object.new.respond_to?(method_alias, true)
    end

    def disable
      disable_for(Kernel.singleton_class) if Kernel.respond_to?(method_alias, true)
      disable_for(Kernel)                 if Object.new.respond_to?(method_alias, true)
    end

    private

    def method_alias
      "__un_shell_mocked_#{interpolatable_name}"
    end

    def interpolatable_name
      method_name
    end

    def enable_for(class_or_module)
      class_or_module.send(:alias_method, method_alias, method_name)

      begin
        # so we don't have to see method redefinition warnings
        class_or_module.send(:remove_method, method_name)
      rescue NameError
      end

      class_or_module.send(:define_method, method_name, &method(:override))
    end

    def disable_for(class_or_module)
      begin
        # so we don't have to see method redefinition warnings
        class_or_module.send(:remove_method, method_name)
      rescue NameError
      end

      class_or_module.send(:alias_method, method_name, method_alias)

      begin
        class_or_module.send(:remove_method, method_alias)
      rescue NameError
      end
    end
  end
end

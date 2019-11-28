require 'shell_mock/no_stub_specified'

module ShellMock
  class MonkeyPatch
    def enable
      enable_for(Kernel.singleton_class) unless enabled_for?(Kernel)
      enable_for(Kernel)                 unless enabled_for?(Object.new)
    end

    def disable
      disable_for(Kernel.singleton_class) if enabled_for?(Kernel)
      disable_for(Kernel)                 if enabled_for?(Object.new)
    end

    private

    def method_alias
      "__un_shell_mocked_#{interpolatable_name}"
    end

    def interpolatable_name
      method_name
    end

    # @param patch_status_indicator [#respond_to?]
    def enabled_for?(patch_status_indicator)
      patch_status_indicator.respond_to?(method_alias, true)
    end

    # @param patch_target [Class, Module]
    def enable_for(patch_target)
      patch_target.send(:alias_method, method_alias, method_name)

      begin
        # so we don't have to see method redefinition warnings
        patch_target.send(:remove_method, method_name)
      rescue NameError
      end

      patch_target.send(:define_method, method_name, &method(:override))
    end

    # @param patch_target [Class, Module]
    def disable_for(patch_target)
      begin
        # so we don't have to see method redefinition warnings
        patch_target.send(:remove_method, method_name)
      rescue NameError
      end

      patch_target.send(:alias_method, method_name, method_alias)

      begin
        patch_target.send(:remove_method, method_alias)
      rescue NameError
      end
    end
  end
end

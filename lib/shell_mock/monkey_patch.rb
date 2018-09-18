require 'shell_mock/no_stub_specified'

module ShellMock
  class MonkeyPatch
    attr_reader :original, :alias_for_original

    def initialize(original_name, interpolatable_name = original_name, &block)
      @original           = original_name
      @alias_for_original = "__un_shell_mocked_#{interpolatable_name}"
      @replacement        = "__shell_mocked_#{interpolatable_name}"
      @block              = block
    end

    def to_proc
      @block.to_proc
    end

    def enable_for(class_or_module)
      class_or_module.send(:alias_method, alias_for_original, original)

      begin
        # so we don't have to see method redefinition warnings
        class_or_module.send(:remove_method, original)
      rescue NameError
      end

      class_or_module.send(:define_method, original, &to_proc)
    end

    def disable_for(class_or_module)
      begin
        # so we don't have to see method redefinition warnings
        class_or_module.send(:remove_method, original)
      rescue NameError
      end

      class_or_module.send(:alias_method, original, alias_for_original)

      begin
        class_or_module.send(:remove_method, alias_for_original)
      rescue NameError
      end
    end
  end
end

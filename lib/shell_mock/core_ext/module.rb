module ShellMock
  module CoreExt
    module Module
      module Methods
        def deprecate(name, replacement, version)
          old_name = :"#{name}_without_deprecation"

          alias_method old_name, name

          define_method(name) do |*args, &blk|
            warn "ShellMock: ##{name} is deprecated and will be removed by #{version}. "\
              "Please use #{replacement} instead."
            send old_name, *args, &blk
          end
        end
      end
    end
  end
end

Module.include ShellMock::CoreExt::Module::Methods

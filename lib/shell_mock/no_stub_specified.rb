module ShellMock
  class NoStubSpecified < StandardError
    def initialize(env, command, **options)
      super("no stub specified for #{command}")
    end
  end
end

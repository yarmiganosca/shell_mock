module ShellMock
  class NoStubSpecified < StandardError
    def initialize(command)
      super("no stub specified for #{command}")
    end
  end
end

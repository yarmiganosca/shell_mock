Module.class_exec do
  def eigenclass
    @eigenclass ||= class << self; self; end
  end

  def eigenclass_exec(&block)
    eigenclass.class_exec(&block)
  end
end

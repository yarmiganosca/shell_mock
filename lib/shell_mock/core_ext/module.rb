Module.class_exec do
  def eigenclass
    @eigenclass ||= class << self; self; end
  end
end

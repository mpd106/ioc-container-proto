class Ioc
  def initialize
    @bindings = {}
    @created = {}
  end

  # Bind argument name to class to instantiate
  def bind(arg_name, klass)
    @bindings[arg_name] = klass
  end

  # Get a singleton instance of the class corresponding to the symbol
  def resolve(symbol)
    instance = @created[symbol] || construct(symbol)
  end

  private

  def construct(symbol)
    klass = get_binding symbol
    parameters = get_constructor_args(klass)
    dependees = resolve_dependencies(parameters)
    @created[symbol] = klass.new(*dependees)
    return @created[symbol]
  end

  def resolve_dependencies(parameters)
    dependees = []
    parameters.each do |parameter|
      dependees << resolve(parameter)
    end
    return dependees
  end

  def get_binding(symbol)
    @bindings[symbol] || get_class_from_symbol(symbol)
  end

  def get_class_from_symbol(symbol)
    return constantize(symbol.to_s.capitalize)
  end

  def get_constructor_args(klass)
    result = [];
    return klass.instance_method(:initialize).parameters.map(&:last)
  end

  def constantize(camel_cased_word)
    unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
      raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
    end

    Object.module_eval("::#{$1}", __FILE__, __LINE__)
  end
end

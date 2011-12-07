module ViewBuilder
  module TemplateMethods
    attr_reader :template

    def method_missing(method_name, *args, &block)
      if self.template.respond_to?(method_name)
        self.template.send(method_name, *args, &block)
      else
        raise NoMethodError.new("#{self} not has a method, that is #{method_name}.", method_name, args)
      end
    end
  end
end


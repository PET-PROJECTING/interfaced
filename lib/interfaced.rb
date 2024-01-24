# frozen_string_literal: true

require_relative "interfaced/version"

# A module for implementing Java-like interfaces in Ruby.
# More information about Java interfaces:
# http://java.sun.com/docs/books/tutorial/java/concepts/interface.html

module Interfaced
  class MethodMissing < StandardError; end

  private def extend_object(obj) # based on https://www.rubydoc.info/stdlib/core/1.8.7/Module#extend_object-instance_method callback
    return append_features(obj) if obj.is_a?(Interfaced)

    append_features(class << obj; self end) # source code: https://github.com/ruby/ruby/blob/9c236f114001fb557fde97632136c84e669e489c/eval.c#L1029
    included(obj)
  end

  private def append_features(mod) # based on https://www.rubydoc.info/stdlib/core/1.8.7/Module:append_features
    return super if mod.is_a?(Interfaced)

    # Taking required methods from sub interfaces
    sub_interfaces = (ancestors - [self]).select { |x| x.is_a?(Interfaced) }
    inherited_req_methods = sub_interfaces.map { |x| x.instance_variable_get('@req_methods') }

    # Store required methods (both from current interface and sub interfaces)
    req_methods = @req_methods + inherited_req_methods.flatten
    @unreq_methods ||= []

    # Iterate over the list of required methods, and raise
    # an error if the method has not been defined.
    (req_methods - @unreq_methods).uniq.each do |req_method|
      unless mod.instance_methods(true).include?(req_method)
        raise Interfaced::MethodMissing, req_method
      end
    end

    super mod
  end

  # Accepts an array of method names that define the interface. When this
  # module is included/implemented, those method names must have already been
  # defined or error Interfaced::MethodMissing will be raised.
  def required_methods(*req_methods)
    @req_methods = req_methods
  end

  # Accepts an array of method names that are to be removed from required list.
  # Presumably you would use this in a sub-interfaces where
  # you only wanted a partial implementation of an existing interface.
  def unrequired_methods(*unreq_methods)
    @unreq_methods ||= []
    @unreq_methods += unreq_methods
  end

  alias :extends :extend
end

class Object
  # The interfaced method (or its alias `interface`) created an interface module
  # that sets a list of methods that must be included or implemented
  # If the methods are not defined, an Interfaced::MethodMissing error is raised.
  # An Interface can extend any other existing interfaces as well.
  # The similar implementation to TypeScript
  # (https://www.typescripttutorial.net/typescript-tutorial/typescript-extend-interface/)
  #
  # Examples:
  #
  #   # require :foo and :bar methods
  #   FooBarInterface = interfaced_with { # interface, interfaced, create_interface are alies
  #     required_methods :foo, :bar
  #   }
  #
  #   # A sub-interface that extends FooBarInterface but make changes to it
  #   FooBazInterface = interfaced_with {
  #     extends FooBarInterface # extend is an alias
  #     required_methods :baz
  #     unrequired_methods :bar
  #   }
  #
  #   # Raises an Interfaced::MethodMissing error because :bar is not defined.
  #   class MyClass
  #     def foo = ...
  #     def baz = ...
  #
  #     implements FooBazInterface # use_interface is an alias
  #   end
  #
  def interfaced_with(&block)
    Module.new do |mod|
      mod.extend(Interfaced)
      mod.instance_eval(&block)
    end
  end

  alias :interface :interfaced_with
  alias :interfaced :interfaced_with
  alias :create_interface :interfaced_with
end

class Module
  alias :implements :include
  alias :use_interface :include
end

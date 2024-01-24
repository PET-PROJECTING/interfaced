## Description
This module provides Java-like interfaces for Ruby, including a somewhat
similar syntax.

## Installation
`gem install interfaced`

## Usage
### Regular interface
```ruby
require "interfaced"

# regular interface
FooBarInterface = interfaced_with {
  required_methods :foo, :bar
}

class FooClass
  def foo = puts "foo"

  # raises an Interfaced::MethodMissing error
  # since required :bar method is not implemented
  use_interface FooBarInterface
end
```
### Composed interfaces
#### You can extend existing interface
```ruby
FooBarBazInterface = interfaced_with {
  extends FooBarInterface
  required_methods :baz
} # expects :foo, :bar, :baz methods to be implemented
```
#### You can reduce extended interface
```ruby
FooInterface = interfaced_with {
  extends FooBarInterface
  unrequired_methods :bar
} # expect only :foo method to be implemented
```
### Aliases
#### Defining interface
```ruby
variant_a = interfaced_with {}
variant_b = interface {}
variant_c = interfaced {}
variant_d = create_interface {}
```
#### Using interface
```ruby
variant_a = Class A; implements InterfaceA; end
variant_b = Class B; use_interface InterfaceB; end
variant_c = Class C; include InterfaceC; end
```

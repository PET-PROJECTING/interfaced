require "rspec"
require "interfaced"

RSpec.describe Interfaced do
  foo_bar_interface = interfaced_with do
    required_methods :foo, :bar
  end

  foo_baz_interface = interfaced_with do
    extends foo_bar_interface
    required_methods :baz
    unrequired_methods :bar
  end

  let(:empty_class) { Class.new }

  let(:foo_bar_class) do
    Class.new do
      def foo; end

      def bar; end
    end
  end

  let(:foo_baz_class) do
    Class.new do
      def foo; end

      def baz; end
    end
  end

  describe "version" do
    subject { Interfaced::VERSION }

    it { is_expected.to eq("0.1.0") }
    it { is_expected.to be_frozen }
  end

  describe "#interfaced_with" do
    context "with single interface" do
      context "foo_bar_interface interface with :foo and :bar required method" do
        context "casting on empty class (without required method being implemented)" do
          it "raises an error" do
            expect { empty_class.new.extend(foo_bar_interface) }.to raise_error(Interfaced::MethodMissing)
          end
        end

        context "casting on class with :foo and :bar methods being implemented" do
          it "doesn't raise an error" do
            expect { foo_bar_class.new.extend(foo_bar_interface) }.not_to raise_error
          end
        end

        context "casting on class with :foo and :baz methods being implemented" do
          it "raises an error" do
            expect { foo_baz_class.new.extend(foo_bar_interface) }.to raise_error(Interfaced::MethodMissing)
          end
        end
      end

      context "foo_baz_interface with :foo and :baz required methods (:foo and :bar from sub interface, :bar unrequired)" do
        context "casting on empty class (without required method being implemented)" do
          it "raises an error" do
            expect { empty_class.new.extend(foo_baz_interface) }.to raise_error(Interfaced::MethodMissing)
          end
        end

        context "casting on class with :foo and :bar methods being implemented" do
          it "raises an error" do
            expect { foo_bar_class.new.extend(foo_baz_interface) }.to raise_error(Interfaced::MethodMissing)
          end
        end

        context "casting on class with :foo and :baz methods being implemented" do
          it "doesn't raise an error" do
            expect { foo_baz_class.new.extend(foo_baz_interface) }.not_to raise_error
          end
        end
      end
    end

    context "with multiple interfaces" do
      context "casting on empty class (without required method being implemented" do
        it "raises an error" do
          expect do
            empty_class.new.extend(foo_bar_interface)
            empty_class.new.extend(foo_baz_interface)
          end.to raise_error(Interfaced::MethodMissing)
        end
      end

      context "casting on class with :foo and :bar methods being implemented" do
        it "raises and error" do
          expect do
            foo_bar_class.new.extend(foo_bar_interface)
            foo_bar_class.new.extend(foo_baz_interface)
          end.to raise_error(Interfaced::MethodMissing)
        end
      end

      context "casting on class with :foo and :baz methods being implemented" do
        context "when one of interface with required method that class doesn't implement" do
          it "raises an error" do
            expect do
              foo_baz_class.new.extend(foo_bar_interface)
              foo_baz_class.new.extend(foo_baz_interface)
            end.to raise_error(Interfaced::MethodMissing)
          end
        end

        context "when both interfaces with required methods that class implements" do
          foo_interface = interface { required_methods :foo }
          baz_interface = interface { required_methods :baz }

          it "doesn't raise an error" do
            expect do
              foo_baz_class.new.extend(foo_interface)
              foo_baz_class.new.extend(baz_interface)
            end.not_to raise_error
          end
        end
      end
    end
  end
end

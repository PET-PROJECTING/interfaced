# frozen_string_literal: true

require_relative "lib/interfaced/version"

Gem::Specification.new do |spec|
  spec.name = "interfaced"
  spec.version = Interfaced::VERSION
  spec.authors = ["Oleh Klym"]
  spec.email = "k4138314@gmail.com"
  spec.homepage = "https://github.com/PET-PROJECTING/interfaced"
  spec.summary = "Module that providers Java-like interface to Ruby"
  spec.licenses = ["MIT"]
  spec.files = ["lib/interfaced.rb"]
  spec.metadata = { "source_code_uri" => "https://github.com/PET-PROJECTING/interfaced" }
  spec.test_file = "spec/interfaced_spec.rb"

  spec.description = <<-DESC
    Module that providers Java-like interfaces for Ruby.
    It lets you define a set a methods that must be defined in the
    including class or module without the need of inheriting it from interface class.
    Otherwise an error is raised.
  DESC
end

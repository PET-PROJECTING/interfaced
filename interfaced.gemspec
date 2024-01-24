# frozen_string_literal: true

require_relative "lib/interfaced/version"

Gem::Specification.new do |spec|
  spec.name = "interfaced"
  spec.version = Interfaced::VERSION
  spec.required_ruby_version = ">= 2.6.0"
  spec.authors = "Oleh Klym"
  spec.email = "k4138314@gmail.com"
  spec.homepage = "https://github.com/PET-PROJECTING/interfaced"
  spec.summary = "Module that providers Java-like interface to Ruby"
  spec.license = "MIT"

  spec.metadata = {
    "homepage_uri" => "https://github.com/PET-PROJECTING/interfaced",
    "bug_tracker_uri" => "https://github.com/PET-PROJECTING/interfaced/issues",
    "changelog_uri" => "https://github.com/PET-PROJECTING/interfaced/blob/main/CHANGES.md",
    "documentation_uri" => "https://github.com/PET-PROJECTING/interfaced/wiki",
    "source_code_uri" => "https://github.com/PET-PROJECTING/interfaced",
    "wiki_uri" => "https://github.com/PET-PROJECTING/interfaced/wiki",
    "rubygems_mfa_required" => "true"
  }

  spec.test_file = "test/test_interfaced.rb"
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?("bin/", "test/", "spec/", "features/", ".git", ".github", "appveyor", "Gemfile")
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec")
  spec.add_development_dependency("rubocop")

  spec.description = <<-DESC
    Module that providers Java-like interfaces for Ruby.
    It lets you define a set a methods that must be defined in the
    including class or module without the need of inheriting it from interface class.
    Otherwise an error is raised.
  DESC
end

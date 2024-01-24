# frozen_string_literal: true

require "bundler/gem_tasks"

require "rubocop/rake_task"

namespace :gem do
  desc "Create the interfaced gem"
  task create: [:clean] do
    require "rubygems/package"
    spec = Gem::Specification.load("interfaced.gemspec")
    spec.signing_key = File.join(Dir.home, ".ssh", "gem-private_key.pem")
    Gem::Package.build(spec)
  end

  desc "Install the interfaced gem"
  task install: [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

RuboCop::RakeTask.new

task default: %i[spec rubocop]

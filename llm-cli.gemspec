# frozen_string_literal: true

require_relative "lib/llm/cli/version"

Gem::Specification.new do |spec|
  spec.name = "llm-cli"
  spec.version = Llm::Cli::VERSION
  spec.authors = ["Chris Petersen"]
  spec.email = ["chris@petersen.io"]

  spec.summary = "Use ChatGPT to write your shell commands"
  spec.description = "Use ChatGPT to write your shell commands"
  spec.homepage = "https://github.com/cpetersen/llm-cli"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cpetersen/llm-cli"
  spec.metadata["changelog_uri"] = "https://github.com/cpetersen/llm-cli/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{bin/llm}) { |f| File.basename(f) }
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.executables = ["llm"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_development_dependency "rspec"
  # spec.add_dependency "thor"
  spec.add_dependency "json"
  spec.add_dependency "ruby-openai", "~> 4.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

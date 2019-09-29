# frozen_string_literal: true

desc "Run all tests: spec and cucumber (default)"
task test_app: %i[spec cucumber rubocop]

task default: [:test_app]

# frozen_string_literal: true

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

# Defines the matching rules for Guard.
# rubocop:disable Metrics/BlockLength
guard :minitest, spring: "bin/rails test", all_on_start: false do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch("test/test_helper.rb") { "test" }
  watch("config/routes.rb") { integration_tests }
  watch(%r{^app/models/(.*?)\.rb$}) do |matches|
    "test/models/#{matches[1]}_test.rb"
  end
  watch(%r{^app/controllers/(.*?)_controller\.rb$}) do |matches|
    resource_tests(matches[1])
  end
  watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |matches|
    ["test/controllers/#{matches[1]}_controller_test.rb"] +
      integration_tests(matches[1])
  end
  watch(%r{^app/helpers/(.*?)_helper\.rb$}) do |matches|
    integration_tests(matches[1])
  end
  watch("app/views/layouts/application.html.erb") do
    "test/integration/site_layout_test.rb"
  end
  watch("app/helpers/sessions_helper.rb") do
    integration_tests << "test/helpers/sessions_helper_test.rb"
  end
  watch("app/controllers/sessions_controller.rb") do
    ["test/controllers/sessions_controller_test.rb",
     "test/integration/users_login_test.rb"]
  end
  watch("app/controllers/account_activations_controller.rb") do
    "test/integration/users_signup_test.rb"
  end
  watch(%r{app/views/users/*}) do
    resource_tests("users") +
      ["test/integration/posts_interface_test.rb"]
  end
end
# rubocop:enable Metrics/BlockLength

# Returns the integration tests corresponding to the given resource.
def integration_tests(resource = :all)
  if resource == :all
    Dir["test/integration/*"]
  else
    Dir["test/integration/#{resource}_*.rb"]
  end
end

# Returns the controller tests corresponding to the given resource.
def controller_test(resource)
  "test/controllers/#{resource}_controller_test.rb"
end

# Returns all tests for the given resource.
def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end

guard :rubocop do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
end

guard "annotate" do
  watch("db/schema.rb")

  # Uncomment the following line if you also want to run annotate anytime
  # a model file changes
  watch("app/models/**/*.rb")

  # Uncomment the following line if you are running routes annotation
  # with the ":routes => true" option
  watch("config/routes.rb")
end

guard :bundler do
  require "guard/bundler"
  require "guard/bundler/verify"
  helper = Guard::Bundler::Verify.new

  files = ["Gemfile"]
  files += Dir["*.gemspec"] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

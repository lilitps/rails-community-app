# frozen_string_literal: true

namespace :db do
  task dev_reset: %w[db:drop db:create db:migrate db:seed]
end

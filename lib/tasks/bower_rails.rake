# frozen_string_literal: true

namespace :bower do
  desc 'Runs bower:update:prune, bower:clean and bower:resolve'
  task :upgrade do
    Rake::Task['bower:update:prune'].invoke('-f')
    Rake::Task['bower:clean'].invoke
    Rake::Task['bower:resolve'].invoke
    puts 'upgrade complete'
  end
end

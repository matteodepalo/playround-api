task :reset_db do
  ['db:drop', 'db:create', 'db:migrate'].each do |task|
    Rake::Task[task].invoke

    if task == 'db:migrate'
      ENV['RAILS_ENV'] = 'test'
      Rake::Task[task].reenable
      Rake::Task[task].invoke
    end
  end
end
namespace :postdeploy do
  task run: :environment do
    Rake::Task["db:migrate"].invoke
    Rake::Task["trivial:import"].invoke
    Rake::Task["discord_bot:run"].invoke
  end
end

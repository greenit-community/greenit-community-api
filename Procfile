web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq
postdeploy: bundle exec rails db:migrate && bundle exec rails discord_bot:run

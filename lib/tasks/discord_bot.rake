namespace :discord_bot do
  task run: :environment do
    DiscordBotJob.perform_now
  end
end

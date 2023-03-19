class DiscordBotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    bot = Discordrb::Bot.new(token: Rails.application.credentials.dig(:discord_bot, :token))

    bot.message(start_with: "!trivial") do |event|
      question = Question.all.sample

      event.send_embed do |embed, view|
        embed.title = question.sentence.gsub("{", "**").gsub("}", "**")
        embed.description = "#{question.category_title}\nCe Trivial Numérique Responsable est un jeu créé par les équipes d'OM Conseil, adapté en bot Discord pour la communauté Awesome Numérique Responsable."
        view.row do |row|
          question.answers.each_with_index do |answer, index|
            row.button(label: answer, style: :primary, emoji: Question::EMOJIS[index], custom_id: "trivial:#{question.id}:#{answer}")
          end
        end
      end

      bot.add_await!(Discordrb::Events::ButtonEvent, { custom_id: "trivial:#{question.id}:-1", timeout: 15 }) do |button_event|
      end

      event.send_embed do |embed, view|
        embed.title = question.good
        embed.description = "#{question.sentence.gsub("{", "**").gsub("}", "**")}\n#{question.good.gsub("{", "**").gsub("}", "**")}\n#{question.complements.gsub("{", "**").gsub("}", "**")}"
      end

      event.send_embed do |embed, view|
        embed.title = question.actions_title
        embed.description = question.actions.join(", ").gsub("{", "**").gsub("}", "**")
      end
    end

    bot.button(custom_id: /^trivial:/) do |event|
      question_id = event.interaction.button.custom_id.split(':')[1].to_i
      answer = event.interaction.button.custom_id.split(':')[2]

      question = Question.find(question_id)
      if answer.eql?(question.good)
        event.respond(content: "Bonne réponse #{event.user.username} :)")
      else
        event.respond(content: "Mauvaise réponse #{event.user.username} :(")
      end
    end

    bot.run
  end
end

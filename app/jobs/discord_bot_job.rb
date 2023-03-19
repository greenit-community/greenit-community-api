class DiscordBotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    bot = Discordrb::Bot.new(token: Rails.application.credentials.dig(:discord_bot, :token))

    bot.message(start_with: '!trivial') do |event|
      question = Question.all.sample

      question_with_answers = []
      question_with_answers << "Bienvenue ! Ce Trivial Numérique Responsable est un jeu créé par les équipes d'OM Conseil, adapté en bot Discord pour la communauté Awesome Numérique Responsable."
      question_with_answers << question.sentence.gsub("{", "**").gsub("}", "**")
      question.answers.each_with_index do |answer, index|
        question_with_answers << "#{Question::EMOJIS[index]} : #{answer}"
      end
      question_with_answers = question_with_answers.join("\n")

      message = event.respond question_with_answers
      question.answers.length.times do |index|
        message.react Question::EMOJIS[index]
      end

      answer_index = question.answers.index(question.good)
      answer_emoji = Question::EMOJIS[answer_index]

      bot.add_await!(Discordrb::Events::ReactionAddEvent, message: message, emoji: answer_emoji, timeout: 15) do |_reaction_event|
        event.respond "Bonne réponse ! #{question.good}"
      end

      event.respond "Quelques compléments d'information : #{question.complements.gsub("{", "**").gsub("}", "**")}\n#{question.actions_title} : #{question.actions.join(", ").gsub("{", "**").gsub("}", "**")}.\nVous voulez rejouer ? `!trivial`"
    end

    bot.run
  end
end

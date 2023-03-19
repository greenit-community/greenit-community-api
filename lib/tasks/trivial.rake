namespace :trivial do
  task import: :environment do
    json = JSON.parse(File.read(Rails.root.join("data","trivial-numerique-responsable.json")))
    json["categories"].each do |category|
      category["questions"].each do |question|
        question = Question.where(category_title: category["title"], category_order: category["order"], sentence: question["sentence"]).first_or_create(
          category_color: category["color"],
          answers: question["answers"],
          good: question["good"],
          complements: question["complements"],
          actions_title: question["actions_title"],
          actions: question["actions"],
          order: question["order"],
        )
      end
    end
  end
end

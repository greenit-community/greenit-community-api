class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :category_title
      t.integer :category_order
      t.string :category_color
      t.string :sentence
      t.string :answers, array: true, default: []
      t.string :good
      t.string :complements
      t.string :actions_title
      t.string :actions, array: true, defaults: []
      t.integer :order

      t.timestamps
    end
  end
end

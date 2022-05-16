class CreateDiscussions < ActiveRecord::Migration[6.1]
  def change
    create_table :discussions do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name, null: false
      t.boolean :pinned, default: false
      t.boolean :closed, default: false
      t.timestamps
    end
  end
end

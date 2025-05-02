class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :status
      t.datetime :due_date
      t.integer :comments_count, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.references :assigned_to, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :first_user_id
      t.integer :second_user_id
      t.string :board
      t.string :turn
      t.boolean :completed
      t.boolean :accepted

      t.timestamps
    end
  end
end

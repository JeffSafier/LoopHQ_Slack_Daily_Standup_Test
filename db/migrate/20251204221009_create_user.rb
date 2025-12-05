class CreateUser < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :slack_user_id, null: false
      t.string :name, null: false
      t.string :team_id, null: false
      t.index [:name, :team_id], unique: true
      t.timestamps
    end
  end
end

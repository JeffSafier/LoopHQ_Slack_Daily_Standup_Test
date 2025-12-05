class CreateStandupInformation < ActiveRecord::Migration[8.1]
  def change
    create_table :standup_information do |t|
      t.text :yesterdays_work, null: false
      t.text :today_work, null: false
      t.text :blockers
      t.references :users, null: false, foreign_key: true
      t.timestamps
    end
  end
end

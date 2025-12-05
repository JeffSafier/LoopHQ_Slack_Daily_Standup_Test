class CreateStandupInformation < ActiveRecord::Migration[8.1]
  def change
    create_table :standup_information do |t|
      t.date :standup_date
      t.text :yesterdays_work, null: false
      t.text :todays_work, null: false
      t.text :blockers
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
# frozen_string_literal: true

class StandupInformation < ApplicationRecord
  self.table_name = "standup_information"
  belongs_to :user

  validates :standup_date, presence: true
  validates :todays_work, presence: true
  validates :yesterdays_work, presence: true


end

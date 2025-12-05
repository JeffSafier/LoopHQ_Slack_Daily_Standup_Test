# frozen_string_literal: true

class StandupInformation < ApplicationRecord
  belongs_to :user

  self.table_name = "standup_information"
end

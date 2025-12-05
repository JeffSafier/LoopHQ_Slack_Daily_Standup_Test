# frozen_string_literal: true

class User < ApplicationRecord
  has_many :standup_information

  validates :name, presence: true
  validates :team_id, presence: true
  validates :slack_user_id, presence: true
end

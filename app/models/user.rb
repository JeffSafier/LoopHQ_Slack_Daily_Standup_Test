# frozen_string_literal: true

class User < ApplicationRecord
  has_many :standup_information

end

class Report < ApplicationRecord
  validates :comment, presence: true
end

class Member < ApplicationRecord
  has_many :article_members, dependent: :destroy
  has_many :articles, through: :article_members
  validates :name, presence: true, uniqueness: true
end

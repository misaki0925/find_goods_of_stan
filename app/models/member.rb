class Member < ApplicationRecord
  has_many :article_members
  has_many :articles, through: :article_members
end

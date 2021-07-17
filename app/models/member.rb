class Member < ApplicationRecord
  has_many :article_members
  has_many :articles, through: :article_members
  # accepts_nested_attributes_for :article_members, allow_destroy: true
end

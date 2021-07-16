class ArticleMember < ApplicationRecord
  belongs_to :article
  belongs_to :member
end

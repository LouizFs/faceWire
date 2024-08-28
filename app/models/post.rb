class Post < ApplicationRecord
  belongs_to :user

  has_rich_text :content
  has_many :comments, dependent: :destroy

  validates_presence_of :content
end

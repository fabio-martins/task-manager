class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task, counter_cache: true

  validates :content, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end

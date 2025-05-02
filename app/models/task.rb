class Task < ApplicationRecord
  belongs_to :user
  belongs_to :assigned_to, class_name: "User", optional: true
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: %w[todo pending in_progress completed] }

  def assignee
    assigned_to
  end
end

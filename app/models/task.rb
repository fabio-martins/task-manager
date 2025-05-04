class Task < ApplicationRecord
  include Filterable

  belongs_to :user
  belongs_to :assigned_to, class_name: "User", optional: true
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: %w[todo pending in_progress completed] }

  scope :ordered, -> { order(due_date: :asc) }
  scope :search, ->(query) { where("title ILIKE :query OR description ILIKE :query", query: "%#{query}%") }
  scope :assigned_to, ->(user_id) { user_id.to_i.zero? ? all : where(assigned_to_id: user_id) }
  scope :with_due_date_between, ->(start_date, end_date) { where(due_date: start_date..end_date) }

  scope :with_status, ->(status) {
    return all if status == "all" || status.blank?
    where(status: status)
  }

  def status_color
    case status
    when "todo" then "gray"
    when "pending" then "yellow"
    when "in_progress" then "blue"
    when "completed" then "green"
    end
  end

  def assignee
    assigned_to
  end
end

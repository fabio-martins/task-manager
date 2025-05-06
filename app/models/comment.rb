class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task, counter_cache: true

  validates :content, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  after_create_commit do
    broadcast_update_to(
      "task_#{task_id}_comments",
      target: "task_#{task_id}_comments",
      partial: "tasks/comments_list",
      locals: { task: task }
    )
    broadcast_update_to(
      "task_#{task_id}_comment_count",
      target: "task_#{task_id}_comment_count",
      partial: "tasks/comment_count",
      locals: { task: task }
    )
  end
end

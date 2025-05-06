class NotifyTaskDeadlineJob < ApplicationJob
  queue_as :default

  BATCH_SIZE = 100

  def perform
    Task.where(due_date: Date.tomorrow)
        .where.not(assigned_to_id: nil)
        .find_in_batches(batch_size: BATCH_SIZE) do |tasks|
      tasks.each do |task|
        TaskDeadlineMailer.deadline_reminder(task).deliver_later
      end
    end
  end
end

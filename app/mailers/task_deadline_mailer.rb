class TaskDeadlineMailer < ApplicationMailer
  def deadline_reminder(task)
    @task = task
    mail(
      to: task.assigned_to.email,
      subject: "Reminder: The deadline for the task '#{task.title}' is approaching!"
    )
  end
end

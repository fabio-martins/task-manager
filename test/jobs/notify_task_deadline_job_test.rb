require "test_helper"

class NotifyTaskDeadlineJobTest < ActiveJob::TestCase
  test "should send reminder email for tasks with due date tomorrow and assigned user" do
    user = users(:user_one)
    task1 = tasks(:one)
    task2 = tasks(:two)

    task1.update(due_date: Date.tomorrow, assigned_to: user)
    task2.update(due_date: Date.tomorrow, assigned_to: user)

    perform_enqueued_jobs do
      NotifyTaskDeadlineJob.perform_now
    end

    assert_equal 2, ActionMailer::Base.deliveries.count
    ActionMailer::Base.deliveries.each do |mail|
      assert_equal user.email, mail.to[0]
    end
  end

  test "should not send reminder email for tasks without an assigned user" do
    task = tasks(:one)
    task.update(due_date: Date.tomorrow, assigned_to: nil)

    assert_enqueued_jobs 0
    NotifyTaskDeadlineJob.perform_now
    assert_enqueued_jobs 0
  end

  test "should not send reminder email for tasks with due date other than tomorrow" do
    user = users(:user_one)
    task = tasks(:one)
    task.update(due_date: Date.today, assigned_to: user)

    assert_enqueued_jobs 0
    NotifyTaskDeadlineJob.perform_now
    assert_enqueued_jobs 0
  end
end

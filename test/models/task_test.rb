require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
    @assigned_user = users(:user_two)
    @task = Task.create(title: "Test Task", description: "Task description", status: "todo", user: @user)
  end

  test "should not save task without title" do
    task = Task.new(description: "A task without title", status: "todo", user: @user)
    assert_not task.save, "Saved the task without a title"
  end

  test "should not save task without description" do
    task = Task.new(title: "Task without description", status: "todo", user: @user)
    assert_not task.save, "Saved the task without a description"
  end

  test "should not save task without status" do
    task = Task.new(title: "Task without status", description: "Description", user: @user)
    assert_not task.save, "Saved the task without status"
  end

  test "should not save task with invalid status" do
    task = Task.new(title: "Task with invalid status", description: "Description", status: "invalid_status", user: @user)
    assert_not task.save, "Saved the task with an invalid status"
  end

  test "should save task with valid attributes" do
    task = Task.new(title: "Valid task", description: "Valid description", status: "todo", user: @user)
    assert task.save, "Failed to save a valid task"
  end

  test "should belong to user" do
    assert_equal @user, @task.user, "Task does not belong to the correct user"
  end

  test "should belong to assigned_to user" do
    @task.assigned_to = @assigned_user
    assert_equal @assigned_user, @task.assigned_to, "Assigned task does not belong to the correct user"
  end

  test "should have many comments" do
    comment = Comment.create(content: "This is a comment", task: @task, user: @user)
    assert_includes @task.comments, comment, "Task does not have the correct comments"
  end

  test "should destroy associated comments when task is destroyed" do
    comment = Comment.create(content: "This is a comment", task: @task, user: @user)
    assert_difference("Comment.count", -1) do
      @task.destroy
    end
  end

  test "should return the correct assignee" do
    @task.assigned_to = @assigned_user
    assert_equal @assigned_user, @task.assignee, "Assignee method did not return the correct user"
  end

  test "should return nil if no assignee is set" do
    @task.assigned_to = nil
    assert_nil @task.assignee, "Assignee method did not return nil when no assignee is set"
  end
end

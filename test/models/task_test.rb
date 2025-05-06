require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
    @assigned_user = users(:user_two)
    @task = Task.create(title: "Test Task", description: "Task description", status: "todo", user: @user)
    @task2 = Task.create(title: "Another Task", description: "Another description", status: "in_progress", user: @user, assigned_to: @assigned_user, due_date: 1.day.from_now)
    @task3 = Task.create(title: "Task to be searched", description: "Search description", status: "completed", user: @user)
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
    comment = Comment.create!(content: "This is a comment", task: @task, user: @user)
    @task.reload
    assert_includes @task.comments, comment, "Task does not have the correct comments"
  end

  test "should destroy associated comments when task is destroyed" do
    comment = Comment.create(content: "This is a comment", task: @task, user: @user)
    @task.reload
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

  test "should return correct color for 'todo' status" do
    @task.status = "todo"
    assert_equal "gray", @task.status_color, "Status color for 'todo' is incorrect"
  end

  test "should return correct color for 'pending' status" do
    @task.status = "pending"
    assert_equal "yellow", @task.status_color, "Status color for 'pending' is incorrect"
  end

  test "should return correct color for 'in_progress' status" do
    @task.status = "in_progress"
    assert_equal "blue", @task.status_color, "Status color for 'in_progress' is incorrect"
  end

  test "should return correct color for 'completed' status" do
    @task.status = "completed"
    assert_equal "green", @task.status_color, "Status color for 'completed' is incorrect"
  end

  test "should broadcast task destruction" do
    assert_broadcast_on("tasks", "<turbo-stream action=\"remove\" target=\"task_#{@task.id}\"></turbo-stream>") do
      @task.destroy
    end
  end

  test "should order tasks by due_date" do
    task4 = Task.create(title: "Task 4", description: "Description 4", status: "todo", user: @user, due_date: 2.days.from_now)
    task5 = Task.create(title: "Task 5", description: "Description 5", status: "todo", user: @user, due_date: 3.days.from_now)
    ordered_tasks = Task.where(id: [ @task.id, task4.id, task5.id ]).ordered
    assert_equal [ task4, task5, @task ], ordered_tasks, "Tasks are not ordered by due_date correctly"
  end

  test "should filter tasks by search query in title" do
    result = Task.search("Test")
    assert_includes result, @task, "Search did not return the correct task by title"
  end

  test "should filter tasks by search query in description" do
    result = Task.search("Task description")
    assert_includes result, @task, "Search did not return the correct task by description"
  end

  test "should filter tasks by assigned_to" do
    result = Task.assigned_to(@assigned_user.id)
    assert_includes result, @task2, "Assigned tasks were not filtered correctly"
  end

  test "should return all tasks when assigned_to is 0" do
    result = Task.assigned_to(0)
    assert_includes result, @task, "Task was excluded when assigned_to_id was 0"
  end

  test "should filter tasks by status" do
    result = Task.with_status("in_progress")
    assert_includes result, @task2, "Tasks were not filtered correctly by status"
  end

  test "should return all tasks when status is 'all'" do
    result = Task.with_status("all")
    assert_includes result, @task, "Tasks were not included when status was 'all'"
  end
end

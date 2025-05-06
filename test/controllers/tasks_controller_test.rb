require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    sign_in @user
    @task = tasks(:one)
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should create task" do
    assert_difference("Task.count") do
      post tasks_url, params: { task: { title: "New Task", description: "Task description", status: "todo", due_date: "2025-05-07", assigned_to_id: @user.id } }
    end
    assert_response :found
    follow_redirect!
    assert_response :ok
  end

  test "should update task" do
    patch task_url(@task), params: { task: { title: "Updated Task", description: "Updated description", status: "in_progress" } }
    assert_response :found
    follow_redirect!
    assert_response :ok

    task = @task.reload
    assert_equal "Updated Task", task.title
    assert_equal "Updated description", task.description
    assert_equal "in_progress", task.status
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete task_url(@task)
    end
    assert_response :found
    follow_redirect!
    assert_response :ok
  end

  test "should generate description" do
    post generate_description_tasks_url, params: { title: "Task description" }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert response_data["description"].present?
  end

  test "should filter tasks by status" do
    get tasks_url, params: { with_status: "todo" }
    assert_response :success
  end

  test "should return 404 when task is not found" do
    get task_url(id: "nonexistent_id")
    assert_response :not_found
  end
end

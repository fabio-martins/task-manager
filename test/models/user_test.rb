require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    user = User.new(email: "user@example.com", password: "password", password_confirmation: "password")
    assert user.valid?
  end

  test "should not be valid without email" do
    user = User.new(password: "password", password_confirmation: "password")
    assert_not user.valid?
  end

  test "should not be valid without password" do
    user = User.new(email: "user@example.com")
    assert_not user.valid?
  end

  test "should not be valid with mismatched passwords" do
    user = User.new(email: "user@example.com", password: "password", password_confirmation: "different")
    assert_not user.valid?
  end

  test "should have many tasks" do
    user = users(:user_one)
    task = Task.create!(title: "Test Task", description: "Task description", status: "todo", user: user)
    assert_includes user.tasks, task
  end

  test "should have many comments" do
    user = users(:user_one)
    task = Task.create!(title: "Test Task", description: "Task description", status: "todo", user: user)
    comment = Comment.create!(content: "This is a comment", task: task, user: user)
    assert_includes user.comments, comment
  end
end

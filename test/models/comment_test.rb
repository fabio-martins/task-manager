require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
    @task = tasks(:one)
  end

  test "should be valid with valid attributes" do
    comment = Comment.new(content: "Test comment", user: @user, task: @task)
    assert comment.valid?
  end

  test "should be invalid without content" do
    comment = Comment.new(content: nil, user: @user, task: @task)
    assert_not comment.valid?
    assert_includes comment.errors[:content], "can't be blank"
  end

  test "should be invalid without user" do
    comment = Comment.new(content: "Test comment", user: nil, task: @task)
    assert_not comment.valid?
    assert_includes comment.errors[:user], "must exist"
  end

  test "should be invalid without task" do
    comment = Comment.new(content: "Test comment", user: @user, task: nil)
    assert_not comment.valid?
    assert_includes comment.errors[:task], "must exist"
  end

  test "ordered scope should return comments in descending order of creation" do
    Comment.delete_all

    older = Comment.create!(content: "Old comment", user: @user, task: @task)
    older.update_column(:created_at, 2.days.ago)

    newer = Comment.create!(content: "New comment", user: @user, task: @task)
    newer.update_column(:created_at, 1.day.ago)

    assert_equal [ newer, older ], Comment.ordered.to_a
  end
end

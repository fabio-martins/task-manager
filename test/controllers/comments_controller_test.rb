require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    sign_in @user
    @task = tasks(:one)
    @comment_params = { content: "This is a test comment" }
  end

  test "should create comment for authenticated user" do
    sign_in @user

    assert_difference("@task.comments.count", 1) do
      post task_comments_path(@task), params: { comment: @comment_params }
    end

    assert_redirected_to @task
  end

  test "should not create comment with invalid content" do
    assert_no_difference("@task.comments.count") do
      post task_comments_path(@task), params: { comment: { content: "" } }
    end

    assert_redirected_to @task
    assert_equal "Unable to add comment.", flash[:alert]
  end
end

# test/services/ai_services/open_ai_chat_service_test.rb
require "test_helper"
require "minitest/mock"

class OpenAiChatServiceTest < ActiveSupport::TestCase
  test "returns failure when prompt is blank" do
    service = AiServices::OpenAiChatService.call(prompt: "")
    assert_not service.success?, "Expected service to fail when prompt is blank"
    assert_equal "It is necessary to provide a prompt", service.data[:errors]
  end
end

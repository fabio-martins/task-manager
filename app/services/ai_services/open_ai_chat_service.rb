require "ostruct"

module AiServices
  class OpenAiChatService < ApplicationService
    def call
      return handle_failure(errors: "It is necessary to provide a prompt") if args[:prompt].blank?

      handle_success(result: create_request)
    rescue StandardError => e
      handle_failure(errors: "Internal error while trying to communicate with OpenAI.")
    end

    private

    def create_request
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [ { role: "user", content: args[:prompt] } ],
          max_tokens: 500
        }
      )

      response.dig("choices", 0, "message", "content")
    rescue OpenAI::Error => e
      Rails.logger.warn("[OpenAiChatService]: #{e.message}")
      nil
    rescue StandardError => e
      Rails.logger.error("[OpenAiChatService]: #{e.class} - #{e.message}")
      nil
    end
  end
end

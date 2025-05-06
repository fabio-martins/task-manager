# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      flash.delete(:notice)
    end
  end
end

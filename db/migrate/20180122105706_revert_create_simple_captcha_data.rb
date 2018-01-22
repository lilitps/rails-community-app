# frozen_string_literal: true

require_relative '20171209001423_create_simple_captcha_data'

class RevertCreateSimpleCaptchaData < ActiveRecord::Migration[5.1]
  def change
    revert CreateSimpleCaptchaData
  end
end

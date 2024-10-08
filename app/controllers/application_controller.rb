class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :sign_in_fake_user

  def sign_in_fake_user
    return if Rails.env.production?

    fake_user = User.last
    raise "There are no Users available" unless fake_user

    sign_in fake_user
  end
end

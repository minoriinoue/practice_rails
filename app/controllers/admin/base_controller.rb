class Admin::BaseController < ApplicationController
  before_action :check_admin

  def check_admin
    if !admin_signed_in?
      redirect_to new_admin_session_url
    end
  end
end

class ApplicationController < ActionController::Base
  # 管理者ページの制限
  before_action :authenticate_admin!, if: :admin_url

  def admin_url
    request.fullpath.include?("/admin")
  end
end

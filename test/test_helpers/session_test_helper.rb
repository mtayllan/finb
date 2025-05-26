module SessionTestHelper
  def parsed_cookies
    ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
  end

  def sign_in_default_user
    post sessions_path, params: {username: "default", password: "qwe123"}
    assert cookies[:session_token].present?
  end
end

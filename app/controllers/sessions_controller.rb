class SessionsController < ApplicationController

  def create
    client_id     = '8034c16884a580b037a2'
    client_secret = '3a498e62fc6eb97d074267e3927c688430299714'
    code          = params[:code]
    response      = Faraday.post("https://github.com/login/oauth/access_token?client_id=#{client_id}&client_secret=#{client_secret}&code=#{code}")

    pairs = response.body.split("&")
    response_hash = {}
    pairs.each do |pair|
      key, value = pair.split("=")
      response_hash[key] = value
    end

    token = response_hash["access_token"]

    oauth_response = Faraday.get("https://api.github.com/user?access_token=#{token}")

    auth = JSON.parse(oauth_response.body)

    user          = User.find_or_create_by(uid: auth["id"])
    user.username = auth["login"]
    user.uid      = auth["id"]
    user.token    = token
    user.save

    session[:user_id] = user.id

    redirect_to dashboard_path
  end

end

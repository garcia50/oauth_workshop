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

  end

end

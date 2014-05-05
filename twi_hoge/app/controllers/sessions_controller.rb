# -*- coding: utf-8 -*-
require "pp"

class SessionsController < ApplicationController
  def create

    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) ||
    User.create_with_omniauth(auth)
    session[:user_id] = user.id
    session[:oauth_token] = auth['credentials']['token']
    session[:oauth_token_secret] = auth['credentials']['secret']
    session[:uid]=auth["uid"]
    session[:account_name]=auth["info"]["nickname"]   #ユーザー名
    session[:user_image]=auth["info"]["image"]        #ユーザーのアイコン画像URL
    pp auth


=begin
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = 'cVC6GwGbXTVjbarYbswFJMOBW'
      config.consumer_secret     = 'ZwuMkmOrhVwMmx4YkNiyFVV0slyqwOVQA9KZQxUvyTvBhO0CRl'
      config.access_lsaoken        = auth['credentials']['token']
      config.access_token_secret = auth['credentials']['secret']
    end
=end


    #client.update("I'm tweeting with ruby-gem. test tweet.")
    redirect_to '/contents/rtline', :notice => "認証しました！"


  end



  def destroy
    #session[:user_id] = nil
    reset_session
    #redirect_to '/sessions/destroy', :notice => "認証を外しました"
  end

end


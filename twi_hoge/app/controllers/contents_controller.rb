# encoding: UTF-8



class ContentsController < ApplicationController


  def index
  end



  def check
    #もしセッション変数user_idがなかったら
    #if defined?(session[:account_id]).nil? then
    if session[:uid].nil? then
      redirect_to '/auth/twitter'

    else
    #もしuser_idが存在してたら

      redirect_to '/contents/rtline', :notice => "認証しました！"

    end      


  end



  def rtline



    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = 'cVC6GwGbXTVjbarYbswFJMOBW'
      config.consumer_secret     = 'ZwuMkmOrhVwMmx4YkNiyFVV0slyqwOVQA9KZQxUvyTvBhO0CRl'
      config.access_token        = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
    end

    puts session[:oauth_token]
    puts session[:oauth_token_secret]
    puts session[:uid]
    puts session[:account_name]

    #options = {:count => 200,}
    options = {:count => 50,}
    #@retlist = client.retweeted_by_user("white_iceage000",options) 
    @retlist = client.retweeted_by_user(session[:account_id],options) 


    @output=Array.new

    #@tweet_info = Array.new


    @retlist.each do | status |

      #text = status[:full_text]

=begin
      @tw_data=Hash.new
      @tw_data["uid"]=status.attrs[:user][:id]
      @tw_data["tweet_id"]=status.attrs[:retweeted_status][:id]      
      @tweet_info.push(@tw_data)
=end


#ここからはデータベース操作

      uid = status.attrs[:user][:id]
      tid = status.attrs[:retweeted_status][:id]


      if Model.where(["userid = ? and tweetid = ?", uid,tid ]).empty?
        model_data=Model.new
        model_data.userid=uid
        model_data.tweetid=tid
        model_data.save 
      end


#ここまで

      #image_url=status.attrs[:retweeted_status][:user][:profile_image_url]


=begin
      data=Hash.new
      data["retweet"]=text  
      data["image"]=image_url

      @output.push(data) 
=end 
    end

#    print @tweet_info

      #models=Model.find(:all)
      model=Model.new
      models=Model.all

      models.each do | i |
        data=Hash.new
        data["userid"]= client.status(i.tweetid)[:user][:screen_name]
        data["retweet"]= client.status(i.tweetid)[:user][:profile_image_url]
        data["image"]= client.status(i.tweetid)[:text]
        @output.push(data)
      end

  end 

 


end

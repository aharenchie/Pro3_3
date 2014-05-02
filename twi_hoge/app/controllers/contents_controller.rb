# encoding: UTF-8



class ContentsController < ApplicationController


  def index
  end



  def check
    #もしセッション変数user_idがなかったら
    #if defined?(session[:account_id]).nil? then
    if session[:account_id].nil? then
      puts "hogehogehogehogehogehogehogehogehogehogehogehogehogehoge"
      redirect_to '/auth/twitter'

    else
    #もしuser_idが存在してたら


      #client.update("I'm tweeting with ruby-gem. test tweet.")
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
    puts session[:account_id]


    #options = {:count => 200,}
    options = {:count => 50,}
    #@retlist = client.retweeted_by_user("white_iceage000",options) 
    @retlist = client.retweeted_by_user(session[:account_id],options) 


    @output=Array.new

    @retlist.each do | status |

      text = status[:full_text]


      image_url=status.attrs[:retweeted_status][:user][:profile_image_url]


      data=Hash.new
      data["retweet"]=text  
      data["image"]=image_url

      @output.push(data) 
 
    end
     

  end


end

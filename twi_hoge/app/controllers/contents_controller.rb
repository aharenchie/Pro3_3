# encoding: UTF-8



class ContentsController < ApplicationController


  def index
  end

  def rtline



    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = 'cVC6GwGbXTVjbarYbswFJMOBW'
      config.consumer_secret     = 'ZwuMkmOrhVwMmx4YkNiyFVV0slyqwOVQA9KZQxUvyTvBhO0CRl'
      config.access_token        = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
    end




    #options = {:count => 200,}
    options = {:count => 20,}
    #@retlist = client.retweeted_by_user("white_iceage000",options) 
    @retlist = client.retweeted_by_user(session[:account_id],options) 


    @output=Array.new

    @retlist.each do | status |
      # full_textを指定することで、省略せず全文ツイートを取得
      text = status[:full_text]
      
      #パターンマッチング。正規表現（最短マッチ）を使用
      %r|@(.+?):| =~ text
      p $1

      id=$1


      #%r|(http://(.[^\s]+))| =~ url

      #fixed_text=text.gsub(/(http(s)?:\/\/(.[^\s]+))/,"<a href="+$2+">"+$2+"</a>")





      #image_url=client.retweeted_by_user("white_iceage000")[0][:user].profile_image_uri
      image_url=status.attrs[:retweeted_status][:user][:profile_image_url]


      data=Hash.new
      data["account"]=id
      data["retweet"]=text  
      data["image"]=image_url

      @output.push(data) 
 
    end
     
      print @output
 

  end


end

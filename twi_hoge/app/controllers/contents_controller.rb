# encoding: UTF-8



class ContentsController < ApplicationController


  def index
  end

  #ランキング予定地
  def rtranking
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
    @retlist = client.retweeted_by_user(session[:account_id],options).reverse


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
      uid= status.attrs[:user][:id]
      tid= status.attrs[:retweeted_status][:id]


=begin
      t.string :uid
      t.string :tweetid
      t.string :time
      t.string :re_uid
      t.string :image
      t.text :text
=end

      #hoge=TwiModel.new

      if TwiModel.where(["uid = ? and tweetid = ?", uid,tid ]).empty?

        model_data=TwiModel.new
        model_data.uid = status.attrs[:user][:id]
        model_data.tweetid = status.attrs[:retweeted_status][:id] 
        model_data.time= status.attrs[:retweeted_status][:created_at]
        model_data.re_uid= status.attrs[:retweeted_status][:user][:id]
        model_data.image= status.attrs[:retweeted_status][:user][:profile_image_url]
        model_data.text= status.attrs[:retweeted_status][:text]
        model_data.ret_nickname= status.attrs[:retweeted_status][:user][:screen_name]


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
      #model=Model.new




      #models=TwiModel.all.reverse


      #レコードを取得
      record=TwiModel.all.where(["uid=?",session[:uid]])

     



      #ここからは上限から超えた分のデータを消去　 
      if record.length > 20
        del_count=record.length-20
        #record.limit(del_count).delete_all 
        #TwiModel.delete_all.where(["uid=?",session[:uid]]).limit(del_count)
        #TwiModel.where(["uid=?",session[:uid]]).delete_all.limit(del_count)


        #これが消去するための記述？ でも、逆向きに消去されてしまう　
        #TwiModel.delete(TwiModel.where(:uid => session[:uid]).reverse_order.limit(del_count))
      end




      #取得したレコードをリバース（データベース格納のための整理)
      #models=record.reverse
      models=TwiModel.all.where(["uid=?",session[:uid]]).reverse

      print models


      models.each do | i |
        data=Hash.new
        data["userid"]= i.re_uid
        data["nickname"]=i.ret_nickname
        data["retweet"]= i.text
        data["image"]= i.image
        @output.push(data)
      end

     @output.reverse

  end 

 


end

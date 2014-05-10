# encoding: UTF-8

require "time"


class ContentsController < ApplicationController

  def index
  end




  #ランキング
  def rtranking

    #まず、データベースから情報引き出し
    models=TwiModel.all.where(["uid=?",session[:uid]])


    #ハッシュ作成。ハッシュの構成は{"username"=>[image_url,RT_count]}
 
    rankdata=Hash.new


    models.each do | i |
      #そのユーザーがハッシュのキーに存在しない場合は新規に割り当てる。件数を１とする
      if not rankdata.key?(i.ret_nickname) then    
        rankdata[i.ret_nickname]=[i.image,1]  
      else
      #ハッシュに存在しない場合は、インクリメント。+1する 
      rankdata[i.ret_nickname][1]+=1 
      end
    end

    #ユーザーのリツイートの多さをソートする。大きい順に並べる。返り値はリスト


    rankdata=rankdata.sort{|(k1, v1), (k2, v2)| v2[1] <=> v1[1] }



    #上位３位を求める
    @rank=Array.new

    3.times{|i|
      data=Hash.new
      data["id"]=rankdata[i][0]
      data["image"]=rankdata[i][1][0]
      data["count"]=rankdata[i][1][1]
      @rank.push(data) 
    }

=begin
@rankの構成
１位：rank[0]["id"]でユーザー名、rank[0]["image"]で画像イメージ、rank[0]["count"]でリツイートカウント
２位：rank[1]["id"]でユーザー名、rank[1]["image"]で画像イメージ、rank[2]["count"]でリツイートカウント
３位：rank[2]["id"]でユーザー名、rank[2]["image"]で画像イメージ、rank[3]["count"]でリツイートカウント

=end


    print @rank


  end




  

  def check
    #もしセッション変数user_idがなかったら、auth/twitterへ飛ぶ。auth/twitterからsessionコントローラーへ飛ぶ
    #if defined?(session[:account_id]).nil? then
    if session[:uid].nil? then
      redirect_to '/auth/twitter'

    else
    #もしuser_idが存在してたら,rtlineへ飛ぶ

      redirect_to '/contents/rtline', :notice => "認証しました！"

    end      


  end



  def rtline
    

    print "hugahugaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1111111111111111111!!!!!!!!!!!!!!!!!!!!!!!!!!!"



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



    
    options = {:count => 200,}
    #options = {:count => 20,}

    print "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    @retlist = client.retweeted_by_user(session[:account_id],options)

    print "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"

    #@retlistをリツイートされた時間順に、ツイートの古い順に並び替える
    @retlist=@retlist.sort{|a,b| Time.parse(a.attrs[:created_at])<=>Time.parse(b.attrs[:created_at])}    




    @output=Array.new

    #@tweet_info = Array.new


    @retlist.each do | status |


      print "hogehogehogehogehoge!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"


#ここからはデータベース操作
      uid= status.attrs[:user][:id]
      tid= status.attrs[:retweeted_status][:id]



      if TwiModel.where(["uid = ? and tweetid = ?", uid,tid ]).empty?

        model_data=TwiModel.new
        model_data.uid = status.attrs[:user][:id]
        model_data.tweetid = status.attrs[:retweeted_status][:id] 
        model_data.time= status.attrs[:retweeted_status][:created_at]
        model_data.re_uid= status.attrs[:retweeted_status][:user][:id]
        model_data.image= status.attrs[:retweeted_status][:user][:profile_image_url]
        model_data.text= status.attrs[:retweeted_status][:text]
        model_data.ret_nickname= status.attrs[:retweeted_status][:user][:screen_name]
        model_data.rt_id=status.attrs[:id]

        model_data.save 
      end


#ここまで

    end


      #レコードを取得
      record=TwiModel.all.where(["uid=?",session[:uid]])

     



      @badge = record.length
      #ここからは上限から超えた分のデータを消去　 
      if record.length > 1000
        @badge = 1000
        del_count=record.length-1000
        #record.limit(del_count).delete_all 
        #TwiModel.delete_all.where(["uid=?",session[:uid]]).limit(del_count)
        #TwiModel.where(["uid=?",session[:uid]]).delete_all.limit(del_count)
      

      #これが消去するための記述？ でも、逆向きに消去されてしまう　
      TwiModel.delete(TwiModel.where(:uid => session[:uid]).limit(del_count))
    end
    
  

      #取得したレコードをリバース（データベース格納のための整理)
      #models=record.reverse
      models=TwiModel.all.where(["uid=?",session[:uid]]).reverse


      models.each do | i |
        data=Hash.new
        data["userid"]= i.re_uid
        data["nickname"]=i.ret_nickname
        data["retweet"]= i.text
        data["image"]= i.image
        @output.push(data)
      end


  end 


end

#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

#connect to db syntax via active record
set :database, "sqlite3:leprosoriumAR.db" 


class Post < ActiveRecord::Base
  
  has_many :comments
  
  validates :name, presence: true, # means field can't be empty
            length: { minimum: 3 }
  #or 
  #validates :name, presence => true

  validates :content, presence: true,
             length: { minimum: 3 }

end
 
class Comment < ActiveRecord::Base
   belongs_to :post
end

before do 

   @posts = Post.all
end

get '/' do

    @posts = Post.order "created_at DESC"
    erb :index
end

get '/new' do

   @p = Post.new
   erb :new
end

post '/new' do

   @p = Post.new params[:post]
   if @p.save
     erb "<h2>Thank You! You are submitted!</h2>"
    # redirect '/'
    else 
       @error = @p.errors.full_messages.first
       erb :new
    end

end #post new

get '/details/:post_id' do
  
   if !(@comments = Comment.where(post_id: params[:post_id]) )
    
       @comments = [];
   else
      @comments = Comment.where(post_id: params[:post_id])  
   end

   @post_id = params[:post_id]
   erb :details

end

post '/details/:post_id' do

   @c = Comment.new params[:comment]
   if @c.save
           
      erb '<h2>Comment Added!</h2>'
   else
       
      @error = @c.errors.full_messages.first
   end #if  

end #post details


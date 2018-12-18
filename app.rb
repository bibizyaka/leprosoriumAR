#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'

def init_db

  @db = SQLite3::Database.new 'LeprosoriumHW.db'
  @db_results_as_hash = true #Results will be returned as HASH and not as ARRAY

end

before do 

    init_db # start function with connecting to our DB

end

configure do
   
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts ( 
                 Id INTEGER PRIMARY KEY AUTOINCREMENT ,
                 Name TEXT,
                 Content TEXT,
                 DateTime DateTime
    			 )'

    @db.execute 'CREATE TABLE IF NOT EXISTS Comments ( 
                 Id INTEGER PRIMARY KEY AUTOINCREMENT,
                 Name TEXT,
                 Content TEXT,
                 DateTime DateTime,
                 Post_id INTEGER
    			 )'
   
end

get '/' do

	@Posts = @db.execute 'Select * from Posts Order By Id desc'
    if @Posts.length == 0
       @Posts = []
    end     
	
	erb :index
end



get '/new' do
 
  erb :new

end

post '/new' do

    @author  = params[:author]
    @content = params[:content]

    if @author.strip.size == 0
    
    	@error = "Provide Your Name"
    	erb :new
    
    elsif @content.strip.size == 0
    	
    	@error = "Post Can't Be Empty"
    	erb :new

    else #input data is valid
   
        @db.execute 'Insert into Posts (Name,Content,DateTime) VALUES (?,?,datetime()) ',[@author,@content]
        redirect '/'
    end
end #post new

get '/details/:post_id' do

   @post_id = params[:post_id]
  @Comments = @db.execute 'Select * from Comments where post_id = ?', [@post_id]
  
  if @Comments.size == 0
  
  	@Comments = []
  end

  erb :details

end

post '/details/:post_id' do

    @post_id = params[:post_id]
    @author  = params[:author]
    @content = params[:content]

    if @author.strip.size == 0
    
       @error = "Provide Your Name"
      # erb :details, :locals [@post_id]
    
    elsif @content.strip.size == 0
    	
       @error = "Comment Can't Be Empty"
       #erb :details

    else #input data is valid
   
       @db.execute 'Insert into Comments (Name,Content,DateTime, Post_id) VALUES (?,?,datetime(), ?) ',[@author,@content, @post_id]
       redirect '/'
   
    end   

end


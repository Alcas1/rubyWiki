require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/main.db")

class Wiki
  include DataMapper::Resource
  property :id, Serial
  property :uneditable,Boolean,:default=>false
  property :page_content,Text, :required =>true
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!
get '/' do
  @wikis = Wiki.all :order => :id.desc
  @title = 'All Pages'
  erb :home
end
post '/' do
  page = Wiki.new
  page.created_at = Time.now
  page.updated_at = Time.now
  page.save
  redirect '/newwiki/:id'
end

get '/newwiki/:id' do
  @title = "Create New Page ##{params[:id]}"
  @wiki=Wiki.find(params[:id])

  erb :wiki
end






get '/:id' do
  @wiki = Wiki.get params[:id]
  @title = "Edit page ##{params[:id]}"
  erb :edit
end
put '/:id' do
  page = Wiki.get params[:id]
  page.page_content = params[:page_content]
  page.updated_at = Time.now
  page.save
  redirect '/'
end
get '/:id/delete' do
  @wiki = Wiki.get params[:id]
  @title = "Confirm deletion of page ##{params[:id]}"
  erb :delete
end
delete '/:id' do
  page = Wiki.get params[:id]
  page.destroy
  redirect '/'
end

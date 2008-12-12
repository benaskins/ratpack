require 'rubygems'
require 'sinatra'
require 'sequel'

DB = Sequel.mysql('ratpack_development', :user => 'root', :password => '', :host => 'localhost')

post '/pack/*' do
  redirections = DB[:redirections]
  next_key = redirections.order(:shorturl).last ? redirections.order(:shorturl).last[:shorturl].to_i + 1 : 1
  redirections << {:target => params["splat"], :shorturl => next_key}
  next_key
end

get '/:shorturl' do
  redirections = DB[:redirections]
  if redirection = redirections.filter(:shorturl => params[:shorturl]).first
    redirect redirection[:target]
  else
    "We don't know that url sorry!"
  end
end


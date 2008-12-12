require 'rubygems'
require 'sinatra'
require 'sequel'

configure :development do
  DB = Sequel.mysql('ratpack_development', :user => 'root', :password => '', :host => 'localhost')
end

configure :test do
  DB = Sequel.mysql('ratpack_test', :user => 'username', :password => 'password', :host => 'localhost')
end

configure :production do
  DB = Sequel.mysql('ratpack_production', :user => 'username', :password => 'password', :host => 'localhost')
end


post '/pack/*' do
  redirections = DB[:redirections]
  target = params["splat"]
  if redirection = redirections.first(:target => target)
    redirect "/show/#{redirection[:shorturl]}"
  else
    next_key = redirections.order(:shorturl).last ? redirections.order(:shorturl).last[:shorturl].to_i + 1 : 1
    redirections << {:target => target, :shorturl => next_key}
    redirect "/show/#{next_key}"
  end
end

get '/:shorturl' do
  redirections = DB[:redirections]
  if redirection = redirections.first(:shorturl => params[:shorturl])
    redirect redirection[:target]
  else
    "We don't know that url sorry!\n"
  end
end

get '/show/:shorturl' do
  "Your shorturl is #{request.host}/#{params[:shorturl]}\n"
end
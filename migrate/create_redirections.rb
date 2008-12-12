require 'rubygems'
require 'sequel'

class CreateRedirections < Sequel::Migration
  
  def up
    create_table :redirections do
      bigint :shorturl
      varchar :target
    end
  end
  
  def down
    drop_table :redirections 
  end
  
end

DB = Sequel.mysql('ratpack_development', :user => 'root', :password => '', :host => 'localhost')
CreateRedirections.apply DB, :up
require 'sinatra/base'
require "sinatra/reloader"

require 'haml'

require File.join(File.dirname(__FILE__), 'lib/db')

class App < Sinatra::Base
  enable :logging
  set :views, File.expand_path('./../views', __FILE__)

  configure :development do
    register Sinatra::Reloader
    also_reload './lib/**/*.rb'
  end

  get '/category' do
    haml :"category_list.html"
  end

  get '/category/:name' do
    @category = params[:name]
    @modules = ObjCToolBox::Db::GithubRepo.all
    haml :"category.html"
  end

  run! if __FILE__ == $0
end
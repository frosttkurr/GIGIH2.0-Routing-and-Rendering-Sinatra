require 'sinatra'
# require_relative 'config' # Custom Replit configuration

enable :sessions

get '/' do
  unless session[:username].nil?
    redirect '/welcome'
  else
    @name = 'GenerasiGIGIH'
    erb :index
  end
end

get '/welcome' do
  unless session[:username].nil?
    @name = session[:username]
    erb :index
  else
    redirect '/'
  end
end

get '/login' do
  unless session[:username].nil?
    redirect '/welcome'
  else
    erb :login
  end
end

post '/login' do
  @users = [
    {username: 'admin', password: 'admin'},
    {username: 'syakurr', password: 'syakurr'}
  ]
  unless session[:username].nil?
    redirect '/welcome'
  else
    @users.each do |user|
      if params['username'].eql? user[:username] and params['password'].eql? user[:password]
        session[:username] = params['username']
        redirect '/welcome'
      end
    end
  end
end

get '/items' do
  unless session[:username].nil?
    unless session[:username].eql? 'admin'
      erb :"items/index"
    else
      redirect '/items/new'
    end
  else
    redirect '/login'
  end
end

get '/items/new' do
  unless session[:username].nil?
    unless session[:username].eql? 'admin'
      return 'Only admin can add items'
    else
      erb :"items/new"
    end
  else
    redirect '/login'
  end
end

post '/items/create' do
  if @items.nil?
    @items = []
  end
  
  unless session[:username].nil?
    unless session[:username].eql? 'admin'
      return 'Only admin can add items'
    end
    if params[:name] != '' and params[:category] != '' and params[:price] != ''
      @items << {name: params[:name].capitalize, category: params[:category].capitalize, price: params[:price]}
      erb :"items/index"
    else
      return 'Input all form!'
    end
  else
    redirect '/login'
  end
end

post '/logout' do
  session.clear
  redirect '/'
end
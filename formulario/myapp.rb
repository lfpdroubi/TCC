# myapp.rb
require 'sinatra'

get '/' do
  'Hello world!'
end

post '/fill' do
  puts 'Recebey algo em /fill!'
  'Hello world!'
end

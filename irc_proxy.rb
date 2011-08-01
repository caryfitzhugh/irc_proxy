require 'sinatra'
require 'socket'
require './irc_connection'
require 'ruby-debug'

get "/" do
  [200, "<form method='post'> <input type='text' name='message'/> <input type='submit' value='Send'/></form>"]
end

post "/" do
  IRCConnection.irc_message_post params[:message]
  [200, "Sent #{params[:message]}"]
end

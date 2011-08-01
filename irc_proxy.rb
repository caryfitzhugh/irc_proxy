require 'sinatra'
require 'socket'
require 'yaml'
require 'erb'
require './irc_connection'
require 'ruby-debug'

# Yay, globals!
$config = YAML.load(ERB.new(File.read("./config.yml")).result)
$irc = IRCConnection.new($config)


["/:room", "/"].each do |route|
  get route do
    [200, <<-HTML]
      Use curl:
      <pre>
        curl -X POST -d message=boo #{request.url}ROOMNAME
      </pre>
      <form action="#{ params[:room] || "test"}" method='post'>
        <input type='text' name='message'/>
        <input type='submit' value='Send'/>
      </form>
    HTML
  end
end

get "/favicon.ico" do
  [404, "404"]
end

post "/:room" do
  $irc.irc_message_post('#' + params[:room], params[:message])
  [200, "#{params[:room]} #{params[:message]}"]
end

post "/" do
  $irc.irc_message_post "#tester", params[:message]
  [200, "Sent #{params[:message]}"]
end

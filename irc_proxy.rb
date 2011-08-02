require 'sinatra'
require 'socket'
require 'yaml'
require 'erb'
require './irc_connection'
require 'ruby-debug'

# Yay, globals!
$config = YAML.load(ERB.new(File.read("./config.yml")).result)
$irc = IRCConnection.new($config)

get "/favicon.ico" do
  [404, "404"]
end

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

  post route do
    $irc.irc_message_post (params[:room] || "#tester"), params[:message]
    [200, "Sent #{params[:message]}"]
  end
end


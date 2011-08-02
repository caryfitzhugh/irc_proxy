require 'gserver'
class EchoServer < GServer
 def serve( io )
   loop do
     line = io.readline
     puts ">>> #{line}"
     io.puts( line )
   end
 end
end
echo_server = EchoServer.new( 6667 )
echo_server.audit = true # Turn logging on
echo_server.start        # Start server
echo_server.join         # Prevent exiting while server is running

class IRCConnection
  def self.get
    if !@s
      @s = TCPSocket.open(irc_config[:server], irc_config[:port] || 6667)
      @s.puts "PASS #{irc_config[:password]}" if irc_config[:password]
      @s.puts "NICK #{irc_config[:user_name]}"
      @s.puts "USER #{irc_config[:user_name]} 0 * :#{irc_config[:user_name]}"
      sleep 12
      puts @s.recvmsg_nonblock 5000
      @s.puts "JOIN :#{irc_config[:room]}"
      sleep 7
      puts @s.recvmsg_nonblock 5000
    end
    @s
  end
  def self.irc_config
     {
    :server=>'',
    :port  =>'',
    :password => '',
    :user_name => '',
    :room => ''
    }
  end


  def self.irc_message_post(message)
    c = IRCConnection.get
    c.puts "PRIVMSG #{irc_config[:room]} :#{message}"
  end

  def self.leave_irc
    c = IRCConnection.get
    c.puts "PART :#{irc_config[:room]}"
    c.puts "QUIT"
    puts c.gets until s.eof?
  end
end

class IRCConnection
  def initialize(config = {})
    @config = config
  end

  def connection
    if !@s
      @s = TCPSocket.open(@config[:server], @config[:port] || 6667)
      @s.puts "PASS #{@config[:password]}" if @config[:password]
      @s.puts "NICK #{@config[:nick]}"
      @s.puts "USER #{@config[:nick]} 0 * :#{@config[:nick]}"
      sleep 12
      puts @s.recvmsg_nonblock 5000
    end
    yield @s if block_given?
    @s
  end

  def join_room(room)
    @rooms ||= {}
    if !@rooms[room]
      @s.puts "JOIN :#{room}"
      sleep 7
      puts @s.recvmsg_nonblock 5000
    end
  end

  def irc_message_post(room, message)
    connection do |c|
      join_room(room)
      c.puts "PRIVMSG #{room} :#{message}"
    end
  end

  def leave_irc
    connection do |c|
      @rooms.each do |room|
        c.puts "PART :#{room}"
      end
      c.puts "QUIT"
      puts c.gets until s.eof?
    end
  end
end

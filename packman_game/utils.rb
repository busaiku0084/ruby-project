require "io/console"

module Utils
  def self.read_char_nonblock
    begin
      system("stty raw -echo")
      if IO.select([$stdin], nil, nil, 0.05)
        $stdin.read_nonblock(1)
      end
    rescue IO::WaitReadable
      nil
    ensure
      system("stty -raw echo")
    end
  end

  def self.clear_screen
    system("clear") || system("cls")
  end
end

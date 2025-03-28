require_relative "map"
require_relative "player"
require_relative "ghost"
require_relative "utils"
require "io/console"

class Game
  def initialize
    @map = Map.new
    @player = Player.new(@map.player_start)
    @ghosts = [Ghost.new(@map.ghost_start)]
    @score = 0
    @lives = 3
    @running = true
  end

  def start
    Utils.clear_screen
    while @running
      Utils.clear_screen
      update
      render
      handle_input
      sleep(0.1)
    end
  end

  def update
    @ghosts.each { |ghost| ghost.move(@map, @player.pos) }
    if ghost_hit?
      @lives -= 1
      if @lives <= 0
        @running = false
        puts "\nGAME OVER! Score: #{@score}"
        return
      else
        @player.reset(@map.player_start)
      end
    end
    if @map.eat_dot(@player.pos)
      @score += 10
    end
    @running = false if @map.all_dots_eaten?
  end

  def render
    @map.draw(@player.pos, @ghosts.map(&:pos))
    puts "Score: #{@score}   Lives: #{@lives}"
  end

  def handle_input
    input = Utils.read_char_nonblock
    case input
    when "w" then @player.move(:up, @map)
    when "s" then @player.move(:down, @map)
    when "a" then @player.move(:left, @map)
    when "d" then @player.move(:right, @map)
    when "q" then @running = false
    end
  end

  def ghost_hit?
    @ghosts.any? { |g| g.pos == @player.pos }
  end
end

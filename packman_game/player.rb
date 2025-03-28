class Player
  attr_reader :pos

  def initialize(start_pos)
    @start_pos = start_pos
    @pos = start_pos.dup
  end

  def move(direction, map)
    x, y = @pos
    case direction
    when :up    then try_move(x - 1, y, map)
    when :down  then try_move(x + 1, y, map)
    when :left  then try_move(x, y - 1, map)
    when :right then try_move(x, y + 1, map)
    end
  end

  def reset(pos)
    @pos = pos.dup
  end

  private

  def try_move(new_x, new_y, map)
    if map.empty_at?(new_x, new_y)
      @pos = [new_x, new_y]
    end
  end
end

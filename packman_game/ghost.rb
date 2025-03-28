class Ghost
  attr_reader :pos

  def initialize(start_pos)
    @pos = start_pos.dup
  end

  def move(map, target_pos)
    directions = [:up, :down, :left, :right].shuffle
    directions.each do |dir|
      new_pos = next_pos(@pos, dir)
      if map.empty_at?(*new_pos)
        @pos = new_pos
        break
      end
    end
  end

  private

  def next_pos(pos, dir)
    x, y = pos
    case dir
    when :up    then [x - 1, y]
    when :down  then [x + 1, y]
    when :left  then [x, y - 1]
    when :right then [x, y + 1]
    end
  end
end

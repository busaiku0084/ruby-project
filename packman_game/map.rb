require 'set'

class Map
  attr_reader :player_start, :ghost_start

  def initialize
    @layout = [
      "####################",
      "#........#.........#",
      "#.####.#.#.####.#.#",
      "#.................#",
      "#.####.#.#.####.#.#",
      "#.#....#.#.#....#.#",
      "#.#.######.######.#",
      "#.................#",
      "####################"
    ]
    @player_start = find_position("P") || [1, 1]
    @ghost_start = find_position("G") || [1, 18]
    @dots = Set.new
    initialize_dots
  end

  def find_position(symbol)
    @layout.each_with_index do |row, x|
      y = row.index(symbol)
      return [x, y] if y
    end
    nil
  end

  def initialize_dots
    @layout.each_with_index do |row, x|
      row.chars.each_with_index do |cell, y|
        @dots << [x, y] if cell == '.'
      end
    end
  end

  def empty_at?(x, y)
    @layout[x][y] != '#'
  end

  def eat_dot(pos)
    @dots.delete(pos)
  end

  def all_dots_eaten?
    @dots.empty?
  end

  def draw(player_pos, ghost_positions)
    @layout.each_with_index do |row, x|
      line = row.chars.each_with_index.map do |cell, y|
        if player_pos == [x, y]
          'P'
        elsif ghost_positions.include?([x, y])
          'G'
        elsif @dots.include?([x, y])
          '.'             # ドットが残っている場所だけ `.` を描画
        elsif cell == '#'
          '#'             # 壁はそのまま
        else
          ' '             # それ以外は空白にする
        end
      end.join
      puts line
    end
  end
end

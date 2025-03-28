class Othello
  SIZE = 8
  EMPTY = "."
  BLACK = "B"
  WHITE = "W"
  DIRECTIONS = [-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE, EMPTY) }
    @board[3][3] = WHITE
    @board[4][4] = WHITE
    @board[3][4] = BLACK
    @board[4][3] = BLACK
    @current_player = BLACK
    @history = []

    print "黒プレイヤーの名前（例: あなた）: "
    @black_name = gets.chomp.strip
    print "白プレイヤーの名前（CPUと対戦する場合は \"CPU\" と入力）: "
    @white_name = gets.chomp.strip
  end

  def play
    loop do
      print_board
      puts "Zを入力すると1手戻せます。"

      if legal_moves(@current_player).empty?
        puts "#{player_name(@current_player)} はパスです。"
        switch_player
        if legal_moves(@current_player).empty?
          puts "両者パス。ゲーム終了！"
          break
        end
        next
      end

      if cpu_turn?
        sleep 0.5
        row, col = legal_moves(@current_player).sample
        puts "#{player_name(@current_player)}（CPU）が #{row+1},#{col+1} に打ちました。"
        save_state
        make_move(row, col, @current_player)
        switch_player
        next
      end

      print "#{player_name(@current_player)} の手番。行(1-8) 列(1-8) をスペース区切りで入力: "
      input = gets.chomp

      if input.upcase == "Z"
        undo_move
        next
      end

      row, col = input.split.map { |n| n.to_i - 1 }
      if valid_move?(row, col, @current_player)
        save_state
        make_move(row, col, @current_player)
        switch_player
      else
        puts "無効な手です。もう一度。"
      end
    end

    print_board
    show_result
  end

  def cpu_turn?
    @current_player == WHITE && @white_name.downcase == "cpu"
  end

  def player_name(color)
    color == BLACK ? @black_name : @white_name
  end

  def print_board
    puts "\n  " + (1..SIZE).to_a.join(" ")
    @board.each_with_index do |row, i|
      puts "#{i + 1} " + row.join(" ")
    end
    puts
  end

  def valid_move?(row, col, player)
    return false unless in_bounds?(row, col) && @board[row][col] == EMPTY
    opponent = opponent_of(player)

    DIRECTIONS.any? do |dx, dy|
      x, y = row + dx, col + dy
      count = 0
      while in_bounds?(x, y) && @board[x][y] == opponent
        x += dx
        y += dy
        count += 1
      end
      count > 0 && in_bounds?(x, y) && @board[x][y] == player
    end
  end

  def legal_moves(player)
    moves = []
    SIZE.times do |i|
      SIZE.times do |j|
        moves << [i, j] if valid_move?(i, j, player)
      end
    end
    moves
  end

  def make_move(row, col, player)
    @board[row][col] = player
    flip_discs(row, col, player)
  end

  def flip_discs(row, col, player)
    opponent = opponent_of(player)
    DIRECTIONS.each do |dx, dy|
      x, y = row + dx, col + dy
      discs = []

      while in_bounds?(x, y) && @board[x][y] == opponent
        discs << [x, y]
        x += dx
        y += dy
      end

      if in_bounds?(x, y) && @board[x][y] == player
        discs.each { |r, c| @board[r][c] = player }
      end
    end
  end

  def in_bounds?(row, col)
    row.between?(0, SIZE - 1) && col.between?(0, SIZE - 1)
  end

  def opponent_of(player)
    player == BLACK ? WHITE : BLACK
  end

  def switch_player
    @current_player = opponent_of(@current_player)
  end

  def show_result
    black_count = @board.flatten.count(BLACK)
    white_count = @board.flatten.count(WHITE)
    puts "#{@black_name}（黒）: #{black_count} | #{@white_name}（白）: #{white_count}"
    if black_count > white_count
      puts "🎉 #{@black_name}（黒）の勝ち！"
    elsif white_count > black_count
      puts "🎉 #{@white_name}（白）の勝ち！"
    else
      puts "🤝 引き分け！"
    end
  end

  def save_state
    @history << Marshal.load(Marshal.dump(@board))
  end

  def undo_move
    if @history.empty?
      puts "戻れる手がありません。"
    else
      @board = @history.pop
      switch_player
      puts "1手戻しました。"
    end
  end
end

# 実行部
if __FILE__ == $0
  puts "=== Rubyコマンドラインオセロ（高機能版） ==="
  game = Othello.new
  game.play
end

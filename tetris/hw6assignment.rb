# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  def initialize (point_array, board)
    super
  end

  All_My_Pieces = Piece::All_Pieces.concat([
                rotations([[0, 0], [-1, 0], [1, 0], [0, 1], [1, 1]]), 
                [[[0, 0], [-1, 0], [1, 0], [-2, 0], [2, 0]],
                [[0, 0], [0, -1], [0, 1], [0, -2], [0, 2]]],
                rotations([[0,0],[0,1],[1,0]])
              ])

  Cheat_Piece = [[[0, 0]]]

  def self.next_piece (board)
    if board.is_cheating
      board.is_cheating = false
      MyPiece.new(Cheat_Piece, board)
    else
      MyPiece.new(All_My_Pieces.sample, board)
    end
  end 
end

class MyBoard < Board
  attr_accessor(:is_cheating, :score)

  def initialize (game)
    super(game)
  
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @is_cheating = false
  end

  def rotate_180_degrees
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0...locations.size).each do |index|
      current = locations[index]
      @grid[current[1] + displacement[1]][current[0] + displacement[0]] = 
        @current_pos[index]
    end
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  def cheat
    if @score >= 100 and !@is_cheating
      @score = @score - 100
      @is_cheating = true
    end
  end

  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end
end

class MyTetris < Tetris
  def initialize
    super
  end

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
  
    @root.bind('u', proc {@board.rotate_180_degrees})
    @root.bind('c', proc {@board.cheat})
  end
end



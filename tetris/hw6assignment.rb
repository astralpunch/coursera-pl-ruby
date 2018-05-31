# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  def initialize (point_array, board)
    super
  end

  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
                rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
                [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
                [[0, 0], [0, -1], [0, 1], [0, 2]]],
                rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
                rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
                rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
                rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
                # added pieces
                rotations([[0, 0], [-1, 0], [1, 0], [0, 1], [1, 1]]), 
                [[[0, 0], [-1, 0], [1, 0], [-2, 0], [2, 0]],
                [[0, 0], [0, -1], [0, 1], [0, -2], [0, 2]]],      
                rotations([[0, 0], [1, 0], [0, 1], [0, 0]])]

  Cheat_Piece = [[0, 0], [0, 0], [0, 0], [0, 0]]

  def self.next_piece (board)
    puts board.is_cheating

    if board.is_cheating and board.score >= 100
      MyPiece.new(Cheat_Piece, board)
      board.score = board.score - 100
      board.is_cheating = false
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
    @root.bind('c', proc {@board.is_cheating = true})
  end

end



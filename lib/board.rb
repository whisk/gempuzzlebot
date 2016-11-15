class Board
  attr_accessor :size, :board

  def initialize(size = 4, diff = 0)
    @size = size
    raise 'Board size must be 2 or greater' if size < 2
    raise 'Difficulty must be positive' if diff < 0
    @board = pristine
    shake(@size - 1, @size - 1, diff)
  end

  def move(x, y)
    check(x, y)
    # try all moves
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |i, j|
      if x + i >= 0 && x + i < @size && y + j >= 0 && y + j < @size && @board[x + i][y + j].nil?
        swap(x + i, y + j, x, y)
        return true
      end
    end
    # can't move
    false
  end

  def shake(x, y, shakes_left = 0)
    return if shakes_left == 0

    allowed_moves = [[1, 0], [-1, 0], [0, 1], [0, -1]].select do |i, j|
      x + i >= 0 && x + i < @size && y + j >= 0 && y + j < @size
    end
    raise GameException, 'Unable to shake' if allowed_moves.size == 0
    i, j = allowed_moves.sample
    swap(x, y, x + i, y + j)
    shake(x + i, y + j, shakes_left - 1)
  end

  def victory?
    @board == pristine
  end

  private

  def pristine
    b = (0...@size).map { |n| (n * @size ... (n + 1) * @size).map { |x| x + 1 } }
    b[-1][-1] = nil
    b
  end

  def check(x, y)
    raise "[#{x}:#{y}] is out of board's bound" if x < 0 || x > @size || y < 0 || y > @size
  end

  def swap(x1, y1, x2, y2)
    check(x1, y1)
    check(x2, y2)
    @board[x1][y1], @board[x2][y2] = @board[x2][y2], @board[x1][y1]
  end
end

require 'minitest/autorun'
require 'mocha/mini_test'

require_relative '../lib/board.rb'

class TestBoard < Minitest::Test
  def test_new_board
    b = Board.new(4)
    assert_equal [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, nil]], b.board
  end

  def test_move
    b = Board.new(4)
    assert_equal false, b.move(3, 3)
    assert_equal [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, nil]], b.board
    b = Board.new(4)
    assert_equal true, b.move(3, 2)
    assert_equal [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, nil, 15]], b.board
    b = Board.new(4)
    assert_equal true, b.move(2, 3)
    assert_equal [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, nil], [13, 14, 15, 12]], b.board
  end

  def test_moves_sequence
    b = Board.new(4)
    b.move(3, 2)
    b.move(3, 1)
    b.move(3, 0)
    b.move(2, 0)
    b.move(1, 0)
    b.move(0, 0)
    b.move(0, 1)
    assert_equal [[2, nil, 3, 4], [1, 6, 7, 8], [5, 10, 11, 12], [9, 13, 14, 15]], b.board
  end

  def test_victory
    b = Board.new(4)
    b.board = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, nil]]
    assert b.victory?
  end

  def test_not_victory
    b = Board.new(4)
    b.board = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, nil, 15]]
    assert_equal false, b.victory?
  end

  def test_shake
    b = Board.new(4)
    b.shake(3, 3, 1)
    assert nil != b.board[-1][-1]
  end
end

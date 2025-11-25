# frozen_string_literal: true

require 'test_helper'

class StackingOrderTest < Minitest::Test
  def test_zero_entries
    assert_equal [], StackingOrder.order(entries: 0, rows: 1, columns: 1)
  end

  def test_basic_examples
    assert_equal [1, 2], StackingOrder.order(entries: 2, rows: 1, columns: 2)
    assert_equal [1, 3, 2], StackingOrder.order(entries: 3, rows: 1, columns: 2)
    assert_equal [1, 4, 2, 5, 3], StackingOrder.order(entries: 5, rows: 1, columns: 2)
  end

  def test_multi_row_grid
    expected = [1, 5, 9, 13, 2, 6, 10, nil, 3, 7, 11, nil, 4, 8, 12]
    assert_equal expected, StackingOrder.order(entries: 13, rows: 2, columns: 2)
  end

  def test_large_case
    result = StackingOrder.order(entries: 895, rows: 7, columns: 3)
    assert_equal 895, result.compact.length
    assert_equal 895, result[result.index(895)]
  end

  def test_argument_validation
    assert_raises(ArgumentError) { StackingOrder.order(entries: -1, rows: 1, columns: 1) }
    assert_raises(ArgumentError) { StackingOrder.order(entries: 1, rows: 0, columns: 1) }
    assert_raises(ArgumentError) { StackingOrder.order(entries: 1, rows: 1, columns: 0) }
  end
end

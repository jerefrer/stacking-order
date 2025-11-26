# frozen_string_literal: true

require 'test_helper'

class StackingOrderTest < Minitest::Test
  def test_2_entries_1_row_2_columns
    assert_equal [1, 2], StackingOrder.order(entries: 2, rows: 1, columns: 2)
  end

  def test_3_entries_1_row_2_columns
    assert_equal [1, 3, 2], StackingOrder.order(entries: 3, rows: 1, columns: 2)
  end

  def test_5_entries_1_row_2_columns
    assert_equal [1, 4, 2, 5, 3], StackingOrder.order(entries: 5, rows: 1, columns: 2)
  end

  def test_6_entries_1_row_2_columns
    assert_equal [1, 4, 2, 5, 3, 6], StackingOrder.order(entries: 6, rows: 1, columns: 2)
  end

  def test_6_entries_2_rows_2_columns
    assert_equal [1, 3, 5, nil, 2, 4, 6], StackingOrder.order(entries: 6, rows: 2, columns: 2)
  end

  def test_13_entries_2_rows_2_columns
    assert_equal [1, 5, 9, 13, 2, 6, 10, nil, 3, 7, 11, nil, 4, 8, 12],
                 StackingOrder.order(entries: 13, rows: 2, columns: 2)
  end

  # Edge cases
  def test_0_entries_1_row_1_column
    assert_equal [], StackingOrder.order(entries: 0, rows: 1, columns: 1)
  end

  def test_1_entry_1_row_1_column
    assert_equal [1], StackingOrder.order(entries: 1, rows: 1, columns: 1)
  end

  def test_exactly_fills_one_page
    # 4 entries perfectly fill one 2x2 grid
    assert_equal [1, 2, 3, 4], StackingOrder.order(entries: 4, rows: 2, columns: 2)
  end

  def test_exactly_fills_multiple_pages
    # 8 entries perfectly fill two 2x2 grids
    assert_equal [1, 3, 5, 7, 2, 4, 6, 8], StackingOrder.order(entries: 8, rows: 2, columns: 2)
  end

  # Test with more columns
  def test_1_row_3_columns
    assert_equal [1, 4, 7, 2, 5, 8, 3, 6, 9], StackingOrder.order(entries: 9, rows: 1, columns: 3)
  end

  def test_5_entries_1_row_3_columns
    assert_equal [1, 3, 5, 2, 4], StackingOrder.order(entries: 5, rows: 1, columns: 3)
  end

  # Test with more rows
  def test_3_rows_1_column
    assert_equal [1, 2, 3], StackingOrder.order(entries: 3, rows: 3, columns: 1)
  end

  def test_5_entries_3_rows_1_column
    # 5 entries in 3x1 grid = 2 pages
    # Cell 0: entries 1,2; Cell 1: entries 3,4; Cell 2: entry 5
    assert_equal [1, 3, 5, 2, 4], StackingOrder.order(entries: 5, rows: 3, columns: 1)
  end

  # Test larger grids
  def test_3_rows_3_columns
    # 27 entries = 3 pages of 3x3
    assert_equal [1, 4, 7, 10, 13, 16, 19, 22, 25,
                  2, 5, 8, 11, 14, 17, 20, 23, 26,
                  3, 6, 9, 12, 15, 18, 21, 24, 27],
                 StackingOrder.order(entries: 27, rows: 3, columns: 3)
  end

  def test_10_entries_3_rows_2_columns
    # 10 entries in 3x2 grid = 2 pages (6 cells/page)
    assert_equal [1, 3, 5, 7, 9, nil, 2, 4, 6, 8, 10],
                 StackingOrder.order(entries: 10, rows: 3, columns: 2)
  end

  # Test partial page at end
  def test_15_entries_2_rows_2_columns
    # 15 entries in 2x2 grid = 4 pages
    assert_equal [1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12],
                 StackingOrder.order(entries: 15, rows: 2, columns: 2)
  end

  def test_2_entries_2_rows_2_columns
    # Only 2 entries in a 2x2 grid (1 page with 4 cells)
    # Cell 0: entry 1, Cell 1: entry 2, Cells 2-3: nil
    assert_equal [1, 2],
                 StackingOrder.order(entries: 2, rows: 2, columns: 2)
  end

  def test_895_entries_7_rows_3_columns
    # Large test case: 895 entries with 7 rows, 3 columns
    # 21 cells per page, so 895/21 = 42.619... = 43 pages
    # Last entry (895) should be at page 35 (0-indexed 34), row 7, col 3
    # Page 36 onwards will have some empty cells

    result = StackingOrder.order(entries: 895, rows: 7, columns: 3)
    cells_per_page = 21

    # Check that we have the correct number of non-nil entries
    assert_equal 895, result.compact.length

    # Check page 1 (indices 0-20)
    page_1 = result[0...cells_per_page]
    assert_equal [1, 44, 87,      # Row 1
                  130, 173, 216,   # Row 2
                  259, 302, 345,   # Row 3
                  388, 431, 474,   # Row 4
                  517, 560, 603,   # Row 5
                  646, 689, 732,   # Row 6
                  775, 818, 861],  # Row 7
                 page_1

    # Check page 35 (0-indexed 34, indices 714-734) - last page with all cells filled
    page_35 = result[34 * cells_per_page, cells_per_page]
    assert_equal [35, 78, 121,      # Row 1
                  164, 207, 250,     # Row 2
                  293, 336, 379,     # Row 3
                  422, 465, 508,     # Row 4
                  551, 594, 637,     # Row 5
                  680, 723, 766,     # Row 6
                  809, 852, 895],    # Row 7 - last entry is 895
                 page_35

    # Check page 36 (0-indexed 35, indices 735-755) - has nil in row 7, col 3
    page_36 = result[35 * cells_per_page, cells_per_page]
    assert_equal [36, 79, 122,       # Row 1
                  165, 208, 251,      # Row 2
                  294, 337, 380,      # Row 3
                  423, 466, 509,      # Row 4
                  552, 595, 638,      # Row 5
                  681, 724, 767,      # Row 6
                  810, 853, nil],     # Row 7 - col 3 should be nil (would be 896)
                 page_36

    # Check page 37 (0-indexed 36, indices 756-776)
    page_37 = result[36 * cells_per_page, cells_per_page]
    assert_equal [37, 80, 123,       # Row 1 - should start with 37, not 80!
                  166, 209, 252,      # Row 2
                  295, 338, 381,      # Row 3
                  424, 467, 510,      # Row 4
                  553, 596, 639,      # Row 5
                  682, 725, 768,      # Row 6
                  811, 854, nil],     # Row 7 - col 3 should be nil (would be 897)
                 page_37

    # Check last page (page 43, 0-indexed 42, indices 882-902)
    # Note: trailing nils are removed, so the last page won't have the final nil
    page_43 = result[42 * cells_per_page, cells_per_page]
    assert_equal [43, 86, 129,       # Row 1
                  172, 215, 258,      # Row 2
                  301, 344, 387,      # Row 3
                  430, 473, 516,      # Row 4
                  559, 602, 645,      # Row 5
                  688, 731, 774,      # Row 6
                  817, 860],          # Row 7 - last entry, trailing nil removed
                 page_43
  end

  def test_two_sided_layout_simple
    expected = [1, 3, 4, 2]
    assert_equal expected, StackingOrder.order(entries: 4, rows: 1, columns: 2, two_sided_flipped: true)
  end

  def test_two_sided_layout_with_2_x_2_grid
    expected = [1, 3, 5, nil, nil, nil, 2, 4]
    assert_equal expected, StackingOrder.order(entries: 5, rows: 2, columns: 2, two_sided_flipped: true)
  end

  def test_two_sided_layout_with_2_x_2_grid_and_more_entries
    expected = [1, 4, 7, nil, 8, nil, 2, 5, 3, 6, 9]
    assert_equal expected, StackingOrder.order(entries: 9, rows: 2, columns: 2, two_sided_flipped: true)
  end

  def test_two_sided_layout_with_three_columns
    expected = [1, 4, 7, 8, 5, 2, 3, 6, 9]
    assert_equal expected, StackingOrder.order(entries: 9, rows: 1, columns: 3, two_sided_flipped: true)
  end

  def test_two_sided_layout_multiple_pages
    expected_pages = [
      [1, 5, 9, 13],
      [10, 14, 2, 6],
      [3, 7, 11, 15],
      [12, 16, 4, 8]
    ]
    result = StackingOrder.order(entries: 16, rows: 2, columns: 2, two_sided_flipped: true)
    assert_equal expected_pages, result.each_slice(4).to_a
  end

  def test_argument_validation
    assert_raises(ArgumentError) { StackingOrder.order(entries: -1, rows: 1, columns: 1) }
    assert_raises(ArgumentError) { StackingOrder.order(entries: 1, rows: 0, columns: 1) }
    assert_raises(ArgumentError) { StackingOrder.order(entries: 1, rows: 1, columns: 0) }
  end
end

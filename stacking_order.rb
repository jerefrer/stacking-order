# Calculates the stacking order for printing entries on pages with a grid layout.
#
# When you print multiple pages with a rows x columns grid, then cut all pages
# at once (creating stacks of cells), and place these stacks one below another,
# this function determines what order to print the entries so that the final
# combined stack reads in order from 1 to entries.
#
# @param entries [Integer] Total number of entries to print
# @param rows [Integer] Number of rows in the grid on each page
# @param columns [Integer] Number of columns in the grid on each page
# @return [Array<Integer, nil>] The order in which to print entries (with nil for empty cells)
#
# @example
#   stacking_order(entries: 5, rows: 1, columns: 2)
#   # => [1, 4, 2, 5, 3]
#   #
#   # This means:
#   # Page 1: [1, 4]
#   # Page 2: [2, 5]
#   # Page 3: [3, nil]
#   #
#   # After cutting and stacking:
#   # - Left column stack (bottom to top): 1, 2, 3
#   # - Right column stack (bottom to top): 4, 5, nil
#   # - Place right stack on top of left: final order 1, 2, 3, 4, 5 (bottom to top)
def stacking_order(entries:, rows:, columns:)
  # Handle edge case of 0 entries
  return [] if entries == 0

  cells_per_page = rows * columns
  num_pages = (entries.to_f / cells_per_page).ceil

  result = []

  # For each page
  num_pages.times do |page_index|
    # For each cell position in the grid (in row-major order)
    cells_per_page.times do |cell_index|
      # Calculate which entry number goes in this cell
      # Entries are distributed column-major by cell position across pages
      entry_number = cell_index * num_pages + page_index + 1

      if entry_number <= entries
        result << entry_number
      else
        result << nil
      end
    end
  end

  # Remove trailing nils
  result.pop while result.last.nil?

  result
end

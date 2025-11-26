# frozen_string_literal: true

require_relative 'stacking_order/version'

# Calculates how to print entries in a grid so that stack-cut pages
# reassemble into sequential order.
module StackingOrder
  module_function

  # Public API for calculating the stacking order for printing entries on pages
  # with a grid layout. See README for details.
  #
  # @param entries [Integer] Total number of entries to print
  # @param rows [Integer] Number of rows in the grid on each page
  # @param columns [Integer] Number of columns in the grid on each page
  # @return [Array<Integer, nil>] The order in which to print entries (with nil for empty cells)
  def order(entries:, rows:, columns:, two_sided_flipped: false)
    validate_arguments!(entries, rows, columns)

    return [] if entries.zero?

    cells_per_page = rows * columns
    num_pages = (entries.to_f / cells_per_page).ceil

    result = []

    num_pages.times do |page_index|
      cells_per_page.times do |cell_index|
        entry_number = (cell_index * num_pages) + page_index + 1
        result << (entry_number <= entries ? entry_number : nil)
      end
    end

    if two_sided_flipped
      result = apply_two_sided_flip(result, rows, columns)
    end

    result.pop while result.last.nil?
    result
  end

  # Utility method that prints the layout for the provided configuration,
  # showing the entries on each page and the resulting stacks after cutting.
  # Useful for debugging or CLI demos.
  def visualize(entries:, rows:, columns:, two_sided_flipped: false, io: $stdout)
    result = order(entries: entries, rows: rows, columns: columns, two_sided_flipped: two_sided_flipped)
    cells_per_page = rows * columns
    num_pages = (entries.to_f / cells_per_page).ceil

    io.puts
    io.puts('=' * 60)
    io.puts("Visualizing stacking order for #{entries} entries, #{rows} row(s), #{columns} column(s)")
    io.puts('=' * 60)
    io.puts("Result: #{result.inspect}")
    io.puts("\nPages layout:")

    result.each_slice(cells_per_page).with_index do |page, page_num|
      io.puts("\nPage #{page_num + 1}:")
      page.each_slice(columns).with_index do |row_values, row_num|
        formatted = row_values.map { |value| value ? format('%3d', value) : 'nil' }.join(' | ')
        io.puts("  Row #{row_num + 1}: #{formatted}")
      end
    end

    io.puts("\nAfter cutting and stacking:")
    cells_per_page.times do |cell_idx|
      row_idx = cell_idx / columns
      col_idx = cell_idx % columns
      stack = []

      num_pages.times do |page_idx|
        pos = (page_idx * cells_per_page) + cell_idx
        stack << (pos < result.length ? result[pos] : nil)
      end

      io.puts("  Position [#{row_idx + 1},#{col_idx + 1}] stack (bottom→top): #{stack.compact.join(', ')}")
    end
  end

  def apply_two_sided_flip(result, rows, columns)
    cells_per_page = rows * columns
    result.each_slice(cells_per_page).with_index.flat_map do |page, page_index|
      padded_page = pad_page(page, cells_per_page)
      page_index.odd? ? flip_page_rows(padded_page, rows, columns) : padded_page
    end
  end

  def pad_page(page, cells_per_page)
    return page if page.length == cells_per_page

    page + Array.new(cells_per_page - page.length)
  end

  def flip_page_rows(page, rows, columns)
    if rows == 1
      row_slice = page.slice(0, columns) || []
      return row_slice.reverse
    end

    flipped = []
    rows.times do |row_index|
      source_row_index = rows - 1 - row_index
      row_slice = page.slice(source_row_index * columns, columns) || []
      flipped.concat(row_slice)
    end
    flipped
  end

  def validate_arguments!(entries, rows, columns)
    raise ArgumentError, 'entries must be non-negative' if entries.negative?
    raise ArgumentError, 'rows must be positive' if rows <= 0
    raise ArgumentError, 'columns must be positive' if columns <= 0
  end
  private_class_method :validate_arguments!
end

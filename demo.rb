#!/usr/bin/env ruby

require_relative 'stacking_order'

def visualize_example(entries:, rows:, columns:)
  result = stacking_order(entries: entries, rows: rows, columns: columns)
  cells_per_page = rows * columns
  num_pages = (entries.to_f / cells_per_page).ceil

  puts "\n" + "=" * 60
  puts "Example: #{entries} entries, #{rows} row(s), #{columns} column(s)"
  puts "=" * 60
  puts "Result: #{result.inspect}"
  puts "\nPages layout:"

  result.each_slice(cells_per_page).with_index do |page, page_num|
    puts "\nPage #{page_num + 1}:"
    page.each_slice(columns).with_index do |row, row_num|
      puts "  Row #{row_num + 1}: #{row.map { |v| v ? "%3d" % v : "nil" }.join(" | ")}"
    end
  end

  puts "\nAfter cutting and stacking:"
  cells_per_page.times do |cell_idx|
    row_idx = cell_idx / columns
    col_idx = cell_idx % columns
    stack = []
    num_pages.times do |page_idx|
      pos = page_idx * cells_per_page + cell_idx
      stack << (pos < result.length ? result[pos] : nil)
    end
    puts "  Position [#{row_idx + 1},#{col_idx + 1}] stack (bottom→top): #{stack.compact.join(", ")}"
  end
end

# Run the examples from the problem statement
visualize_example(entries: 2, rows: 1, columns: 2)
visualize_example(entries: 3, rows: 1, columns: 2)
visualize_example(entries: 5, rows: 1, columns: 2)
visualize_example(entries: 6, rows: 1, columns: 2)
visualize_example(entries: 6, rows: 2, columns: 2)
visualize_example(entries: 13, rows: 2, columns: 2)
visualize_example(entries: 895, rows: 7, columns: 3)


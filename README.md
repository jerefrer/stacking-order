# Stacking Order

A tiny Ruby gem that computes how to arrange records on a paginated grid so that,
after cutting the printed stack into columns and re-stacking them, the final pile
remains in sequential order. It is useful for printing badges, tickets, or any
other grid-based layout that is cut in bulk.

## Installation

```bash
bundle add stacking-order
```

Or add this line to your `Gemfile`:

```ruby
gem 'stacking-order'
```

## Usage

### Library

```ruby
require 'stacking_order'

order = StackingOrder.order(entries: 13, rows: 2, columns: 2)
# => [1, 5, 9, 13, 2, 6, 10, nil, 3, 7, 11, nil, 4, 8, 12]
# nil entries mark empty slots on the final, partially filled page.

StackingOrder.visualize(entries: 6, rows: 2, columns: 2)
# Prints page-by-page grids plus the stack order after cutting.
```

### CLI

```
$ stacking-order --entries 15 --rows 2 --columns 2

Stacking order (15 positions):
[1, 5, 9, 13, 2, 6, 10, nil, 3, 7, 11, nil, 4, 8, 12]


$ stacking-order --entries 6 --rows 2 --columns 2 --visualize

============================================================
Visualizing stacking order for 13 entries, 2 row(s), 2 column(s)
============================================================
Result: [1, 5, 9, 13, 2, 6, 10, nil, 3, 7, 11, nil, 4, 8, 12]

Pages layout:

Page 1:
  Row 1:   1 |   5
  Row 2:   9 |  13

Page 2:
  Row 1:   2 |   6
  Row 2:  10 | nil

Page 3:
  Row 1:   3 |   7
  Row 2:  11 | nil

Page 4:
  Row 1:   4 |   8
  Row 2:  12

After cutting and stacking:
  Position [1,1] stack (bottom→top): 1, 2, 3, 4
  Position [1,2] stack (bottom→top): 5, 6, 7, 8
  Position [2,1] stack (bottom→top): 9, 10, 11, 12
  Position [2,2] stack (bottom→top): 13
```

The CLI prints the resulting sequence (or, with `--visualize`, renders the
page-by-page grids and stack order) and returns non-zero on invalid arguments.

### Real-world usage

This gem powers the stacking order calculations in
[pecha-printer](https://github.com/jerefrer/pecha-printer), which itself backs
the hosted service at <https://pecha-printer.frerejeremy.me>. By publishing the
logic as a gem, the same algorithm can be reused by other Ruby/Rails projects or
invoked manually via the CLI.

## Development

- Run tests: `bundle exec rake test`
- Build the gem: `bundle exec rake build`

Pull requests and issues are welcome.

class SudokuSolver
  attr_reader :board_length, :sub_length, :sub_sub_length, :empty
  def initialize(board_length: 81, empty: '-')
    @board_length      = board_length
    @sub_length        = Math.sqrt(@board_length).to_i
    @sub_sub_length    = Math.sqrt(@sub_length).to_i
    @empty             = empty
    @all_possibilities = (1..@sub_length).map(&:to_s)
  end

  def solve board_string
    empty_index = first_empty_index_of(board_string)
    return board_string unless empty_index
    possibilities_at(empty_index, board_string).each do |possibility|
      solution = solve new_board_with(board_string, possibility, empty_index)
      return solution if solution
    end
    return false
  end

  def possibilities_at(index, board_string)
    @all_possibilities - find_related_indices(index).map {|i| board_string[i]}
  end

  def new_board_with(board_string, possibility, index)
    new_board = board_string.clone
    new_board[index] = possibility
    new_board
  end

  def first_empty_index_of(board_string)
     board_string =~ Regexp.new(empty)
  end

  def find_related_indices(index)
    indices = board_length.times.select {|i| are_related?(i, index) }
  end

  def are_related?(i, index)
    i != index                                 && (
    get_row_number(i) == get_row_number(index) ||
    get_col_number(i) == get_col_number(index) ||
    get_box_number(i) == get_box_number(index)
    )
  end

  def get_row_number i
    i / sub_length
  end

  def get_col_number i
    i % sub_length
  end

  def get_box_number i
    row_group = get_row_number(i) / sub_sub_length
    col_group = get_col_number(i) / sub_sub_length
    row_group * sub_sub_length + col_group
  end

  def format(board_string)
    return "unsolvable" unless board_string
    board_string.chars.each_slice(sub_length).map{|row| row.join(' | ') }.join("\n")
  end
end

if __FILE__ == $0
  if (board = ARGV[0].dup)
    solver = SudokuSolver.new
    puts solver.format solver.solve(board)
  end
end

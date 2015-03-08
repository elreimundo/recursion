class SudokuSolver
  attr_reader :board_length, :sub_length, :sub_sub_length, :empty
  # our initialize method uses Ruby 2.0 named arguments
  # (see https://robots.thoughtbot.com/ruby-2-keyword-arguments)
  # so that we can pass optional board_lengths or empty characters
  # in any order, e.g.
  # SudokuSolver.new(empty: '0')
  # SudokuSolver.new(board_length: 16)
  # SudokuSolver.new(empty: ' ', board_length: 625)
  def initialize(board_length: 81, empty: '-')
    @board_length      = board_length
    @sub_length        = Math.sqrt(@board_length).to_i # 9, like row length
    @sub_sub_length    = Math.sqrt(@sub_length).to_i # 3, like a box is 3x3
    @empty             = empty
    @all_possibilities = (1..@sub_length).map(&:to_s)
  end

  def solve board_string
    # find the first empty index of the board
    empty_index = first_empty_index_of(board_string)
    # If there isn't an empty index, we've solved it.
    return board_string unless empty_index
    # the board isn't done? Crazy! Let's take an educated guess
    possibilities_at(empty_index, board_string).each do |possibility|
      # THIS IS THE RECURSIVE CALL
      # we make a copy of the current board with the current cell changed
      # and attempt to solve it.
      solution = solve new_board_with(board_string, possibility, empty_index)
      # if the solution was valid, send it back up the call chain
      return solution if solution
    end
    # none of the possibilities worked out. A previous guess must
    # have been wrong. Return false so we can go back to a working
    # board
    return false
  end

  def possibilities_at(index, board_string)
    # take all possibilities and remove from them
    # all existing values by first finding all
    # "related" indices (i.e. indices in the)
    # same row, column, and box
    @all_possibilities - find_related_indices(index).
                        # then converting those indices
                        # to the associated cell values
                         map {|i| board_string[i]}.
                        # and finally removing the empty
                        # cells.
                         reject{|char| char == empty}
                        # The last step is unnecessary
                        # since array1 - array2 is a
                        # set difference and empty
                        # is not in @all_possibilities
                        # but it's nice to elucidate
                        # that the return value of
                        # enumerables with blocks
                        # can be chained
  end

  def new_board_with(board_string, possibility, index)
    # make a copy of the board
    new_board = board_string.clone
    # index represents the index of the empty cell
    # change the character at that index by
    # penciling in the possibility
    new_board[index] = possibility
    #finally, return the updated copy of the board
    new_board
  end

  def first_empty_index_of(board_string)
    # see http://ruby-doc.org/core-2.2.0/String.html#method-i-3D-7E
     board_string =~ Regexp.new(empty)
  end

  def find_related_indices(index)
    indices = board_length.times.select {|i| are_related?(i, index) }
  end

  def are_related?(i, index)
    # ignore the original cell
    i != index                                 && (
    # are they in the same row or
    get_row_number(i) == get_row_number(index) ||
    # are they in the same column or
    get_col_number(i) == get_col_number(index) ||
    # are they in the same box
    get_box_number(i) == get_box_number(index)
    )
  end

  def get_row_number i
    # integer division is a nice way of grouping
    # contiguous chunks together
    i / sub_length
  end

  def get_col_number i
    # the modulus is a nice way of determining
    # relative position within cycles
    i % sub_length
  end

  def get_box_number i
    # we're going to use the integer division idea
    # of grouping to group the rows and columns
    # into smaller chunks
    row_group = get_row_number(i) / sub_sub_length
    col_group = get_col_number(i) / sub_sub_length
    row_group * sub_sub_length + col_group
  end

  def format(board_string)
    return "unsolvable" unless board_string
    board_string.chars.each_slice(sub_length).map{|row| row.join(' | ') }.join("\n")
  end
end

# this is a neat trick to allow modules to be included by other files
# (see the sudoku.rb file in the same directory) or run directly
# from the command line. __FILE__ is the path to the current file,
# and $0 is the argument passed to ruby:
#    > ruby sudoku_solver.rb
# has sudoku_solver.rb as its $0 variable
if __FILE__ == $0
  # ARGV is the list of additional arguments passed on the command
  # line after $0.
  # so this file can be run from the command line by calling
  #     > ruby sudoku_solver.rb '-96-4---11---6---45-481-39---795--43-3--8----4-5-23-18-1-63--59-59-7-83---359---7'
  # and it will make a duplicate (non-frozen) copy of the string,
  # then attempt a solution based on that board string
  if (board = ARGV[0].dup)
    solver = SudokuSolver.new
    puts solver.format solver.solve(board)
  end
end

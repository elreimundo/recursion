require_relative 'sudoku_solver'

solver = SudokuSolver.new
boards = File.readlines('boards.txt')

def before_and_after(solver, board)
  puts solver.format(board)
  puts '-' * 33
  puts solver.format(solver.solve(board))
end

if ARGV[0]
  board = boards[ARGV[0].to_i]
  before_and_after(solver, board)
else
  boards.each do |board|
    before_and_after(solver, board)
    puts "=" * 33
  end
end

def factorial(n)
  unless n.is_a? Integer && n >= 0
    raise ArgumentError, "factorial can only be called on whole numbers or 0"
  end
  return 1 if n == 0 || n == 1
  n * factorial(n-1)
end

if __FILE__ == $0
  puts factorial(5)
  puts factorial(3)
end

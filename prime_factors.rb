require 'prime'

#helper methods
def divided_evenly?(n)
  n % 1 == 0
end

def validate(n)
  unless n.is_a? Integer && n > 1
    raise ArgumentError, "n must be an integer greater than 1"
  end
end

#iterative solution
def prime_factors(n)
  validate n
  factors = []
  n = n.to_f
  until Prime.prime?(n)
    Prime.each do |prime|
      factor = n / prime
      if divided_evenly?(n)
        n = factor.to_f
        factors << prime
        break
      end
    end
  end
  factors
end

#recursive solution
def prime_factors_of(n)
  validate n
  return [n] if Prime.prime?(n)
  n = n.to_f
  Prime.each do |prime|
    factor = n / prime
    if divided_evenly?(factor)
      return [prime] + prime_factors_of(factor.to_i)
    end
  end
end

if __FILE__ == $0
  p prime_factors(90)

  p prime_factors_of(90)
  p prime_factors_of(343)
end

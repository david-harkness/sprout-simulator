require './example_game'

# Our Collection of Plants
plants = [
    BambooPlant.new,
    BasicPlant.new,
    BambooPlant.new,
    BambooPlant.new,
    BasicPlant.new,
    BambooPlant.new,
]
# 500 will cause too many files open
50.times.each do |plant|
  plants << BambooPlant.new
end

# Let's play a game
ExampleGame.new(plants).play!

# ---------------- DELETE

# def ec(one_letter)
#   sleep(1)
#   one_letter * 4
# end
#
# # 2 CPUs -> work in 2 processes (a,b + c)
# results = Parallel.map(['a','b','c','d'], in_processes: 4) do |one_letter|
#   puts "next round"
#   ec(one_letter)
# end.join(',')
# puts results

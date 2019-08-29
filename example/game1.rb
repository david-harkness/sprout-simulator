require './example_game'

# Our Collection of Plants
plants = [
    BambooPlant.new,
    BasicPlant.new,
    BambooPlant.new,
]

# Let's play a game
ExampleGame.new(plants).play!

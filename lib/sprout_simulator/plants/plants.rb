require 'sprout_simulator/plants/basic_plant'
require 'sprout_simulator/plants/bamboo_plant'
require 'sprout_simulator/plants/plant_reducer'
require 'sprout_simulator/plants/plant_calculation'

module SproutSimulator::Plants
  # Poor man's type system
  # TODO: seperate fixed and dynamic attributes
  # Dynamic fields should be attributes on BasicPlant
  PlantAttributes = [
      :max_growth_rate,
      :ideal_water,
      :ideal_nutrients,
      :ideal_light_intensity,
      :ideal_light_hours,
  ]
  # Future attributes
  #   :current_stage, enum "seed / sprout / plant / expired"
  #   ideal_container_size
  #   plant_sensitivity: 1 , # multiplier for poor management

  PlantDefaults = {
      max_growth_rate: 20,
      ideal_water: 1.5 , # Amount of water needed per mm of plant
      ideal_nutrients: 5,
      ideal_light_intensity: 5, # 1-10
      ideal_light_hours: 12,  # hours per plant
  }

  # TODO: future
  PlantActions = [
      :feed,
      :adjust_light_intensity,
      :adjust_light_hours,
      :water,
      :prune,
      :apply_pesticide,
      :destroy,
      :harvest,
  ]

  # Plants swiped from https://www.asciiart.eu/plants/bonsai-trees
  PlantAsciiArt1 = <<-FOO
    # (_
      _)\##
  ###/((_
       ))\####
     _((     
####/  )\
     ,;;"`;,
    (_______)
      \===/
      /===\
     /=aat=\
FOO
  PlantAsciiArt2 = <<-FOO
             &&
           &&&&&
         &&&\/& &&&
        &&|,/  |/& &&
         &&/   /  /_&  &&
           \  {  |_____/_&
           {  / /          &&&
           `, \{___________/_&&
            } }{       \
            }{{         \____&
           {}{           `&\&&
           {{}             &&
     , -=-~{ .-^- _
           `}
            {
FOO
  PlantAsciiArt3 = <<-FOO
       ,.,
      MMMM_    ,..,
        "_ "__"MMMMM          ,...,,
 ,..., __." --"    ,.,     _-"MMMMMMM
MMMMMM"___ "_._   MMM"_."" _ """"""
 """""    "" , \_.   "_. ."
        ,., _"__ \__./ ."
       MMMMM_"  "_    ./
        ''''      (    )
 ._______________.-'____"---._.
  \                          /
   \________________________/
   (_)                    (_)
FOO
  SUN1 = <<-FOO
       .
      \ | /
    '-.;;;.-'
   -==;;;;;==-
    .-';;;'-.
      / | \
        '
FOO

 SUN2 = <<-FOO
      ;   :   ;
   .   \_,!,_/   ,
    `.,'     `.,'
     /         \
~ -- :         : -- ~
     \         /
    ,'`._   _.'`.
   '   / `!` \   `
      ;   :   ;
FOO

  SUN3 = <<-FOO
           |
          |   .
   `.  *  |     .'
     `. ._|_* .'  .
   . * .'   `.  *
-------|     |-------
   .  *`.___.' *  .
      .'  |* `.  *
    .' *  |  . `.
        . |
          |
  FOO
end

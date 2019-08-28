# Tossing menu stuff in here.
# Major refactor needed.  Worry about it later
# TTY-table might be a better solution https://atevans.com/2017/08/02/ruby-curses-for-terminal-apps.html
#
#
module MenuMethods
  include Curses
  class << self

    def show_plant_box(plant, top)
      messages = plant.split("\n")
      height = messages.count + 4
      width  = messages.map(&:length).max + 22
      left   = 25
      win = Curses::Window.new(height, width, top, left)
      win.box("*", "*")
      messages.each_with_index do |m, index |
        win.setpos(2 + index, 8)
        win.addstr(m)
      end
      win.refresh
      win.close
    end
    def show_plant_information(message, top)
      messages = message.split("\n")
      height = messages.count + 4
      width  = messages.map(&:length).max + 22
      left   = 55
      win = Curses::Window.new(height, width, top, left)
      win.box("*", "*")
      win.setpos(0, 6)
      win.addstr("Plant Status")
      messages.each_with_index do |m, index |
        win.setpos(2 + index, 3)
        win.addstr(m)
      end
      win.refresh
      win.close
    end

    def set_log_box(message)
      height = 3
      width  = 80
      top    = 25
      left   = 10
      log_box= Curses::Window.new(height, width, top, left)
      log_box.box(".", ".")
      log_box.setpos(0, 6)
      log_box.addstr("Log")
      log_box.setpos(1, 6)
      log_box.addstr(message)
      log_box.refresh
      log_box.close
    end

    def grab_input
      height = 20
      width  = 40
      top    = 2
      left   = 10
      win = Curses::Window.new(height, width, top, left)
      win.box("|", "-")
      win.setpos(0, 6)
      win.addstr("Menu")

      item1 = "Hours of Light (0-24)  : "
      item2 = "Light Intensity (0-10) : "
      item3 = "Water Units (0-500)    : "
      item4 = "Plant Food  (1-1000)   : "
      # item5 = "Harvest (0-1)          : "


      answers = []
      [item1, item2, item3, item4 ].each_with_index do |m, index |
        win.setpos(2 + index, 3)
        win.addstr(m)
        win.refresh
        answers << win.getstr
      end
      win.close
      set_log_box("You have been eaten by a Grue") if answers[1] == "0"
      {hours: answers[0].to_i, intensity: answers[1].to_i, water: answers[2].to_i, food: answers[3].to_i}
    end

    # Unused Currently
    def setup_screen
      Curses.init_screen
      Curses.cbreak
      Curses.stdscr.keypad = true
      # Curses.setpos((Curses.lines - 1) / 2, (Curses.cols - 11) / 2)
    end


    # Render Text Plant
    def show_plant
      render_sun_motion
    end

    def render_sun_motion
      3.times.each do |i|
        if i % 3 == 0
          show_plant_box(SproutSimulator::Plants::SUN3, i+10)
        elsif i % 3 == 1
          show_plant_box(SproutSimulator::Plants::SUN2, i+10)
        else
          show_plant_box(SproutSimulator::Plants::SUN1, i+10)
        end
        sleep 0.5
        Curses.clear
        Curses.refresh

      end
    end

    def teardown_screen
      Curses.close_screen
    end
  end
end


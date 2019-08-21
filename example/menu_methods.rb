# Tossing menu stuff in here.
# Major refactor needed.  Worry about it later
# TTY-table might be a better solution https://atevans.com/2017/08/02/ruby-curses-for-terminal-apps.html
#
#
module MenuMethods
  include Curses
  class << self
    def show_plant_information(message)
      messages = message.split("\n")
      height = messages.count + 4
      width  = messages.map(&:length).max + 22
      top    = 2
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

    def show_menu
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


      answers = []
      [item1, item2, item3].each_with_index do |m, index |
        win.setpos(2 + index, 3)
        win.addstr(m)
        win.refresh
        answers << win.getstr
      end
      win.close
      set_log_box("You have been eaten by a Grue") if answers[1] == "0"
      answers
      {hours: answers[0].to_i, intensity: answers[1].to_i, water: answers[2].to_i}
    end

    def setup_screen
      Curses.init_screen
      Curses.cbreak
      Curses.stdscr.keypad = true
      # Curses.setpos((Curses.lines - 1) / 2, (Curses.cols - 11) / 2)
    end
  end
end


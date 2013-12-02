module Evm
  class ProgressBar
    COLUMNS = 100

    def initialize
      @started = false
    end

    def set(progress)
      progress = progress.to_i

      if progress < 0 || progress > 100
        raise "Invalid progress #{progress}, must be between 0 and 100"
      end

      unless @started
        puts
        @started = true
      end

      print "\e[1A"
      print "\e[K"
      print '['
      print '-' * progress
      print ' ' * (COLUMNS - progress)
      print ']'
      print ' '
      print progress
      print '%'
      puts
    end

    def done
      set 100
    end
  end
end

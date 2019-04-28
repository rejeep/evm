module Evm
  module Command
    class List
      def initialize(*)
        packages = Evm::Package.all.sort{|p1, p2| p1.to_s <=> p2.to_s }
        packages.each do |package|
          if package.current?
            STDOUT.print '* '
          end

          STDOUT.print package

          if package.installed?
            STDOUT.print ' [I]'
          end

          STDOUT.puts
        end
      end
    end
  end
end

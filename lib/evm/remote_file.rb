require 'open-uri'

module Evm
  class RemoteFile
    def initialize(url, options = {})
      @url = url
      @options = options
      @file = options[:file] ||= File
      @uri = options[:uri] ||= URI
    end

    def download(path)
      unless @file.exist?(path)
        @file.open(path, 'w') do |file|
          file.write(@uri.parse(@url).read)
        end
      end
    end
  end
end

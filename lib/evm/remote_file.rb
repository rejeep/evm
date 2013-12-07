require 'uri'
require 'thread'
require 'net/http'

module Evm
  class RemoteFile
    def initialize(url)
      @url = URI.parse(url)
    end

    def download(path, &block)
      return if path.exist?

      file = File.open(path, 'w')

      thread = Thread.new do
        this = Thread.current
        body = this[:body] = []

        http = Net::HTTP.new(@url.host, @url.port)
        http.request_get(@url.path) do |response|
          length = this[:length] = response['Content-Length'].to_i

          response.read_body do |fragment|
            body << fragment

            this[:done] = (this[:done] || 0) + fragment.length
            this[:progress] = this[:done].quo(length) * 100
          end
        end

        file.write(body.join)
      end

      until thread.join(1)
        yield thread[:progress]
      end

      file.close
    end
  end
end

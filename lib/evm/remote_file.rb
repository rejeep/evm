require 'uri'
require 'thread'
require 'net/http'

module Evm
  class RemoteFile
    def initialize(url)
      @url = url
    end

    def download(path, &block)
      return if path.exist?

      file = File.open(path, 'w')

      thread = Thread.new do
        this = Thread.current
        body = this[:body] = []

        request @url do |response|
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

    private

    def request(url, &block)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.request_get(uri.path) do |response|
        case response
        when Net::HTTPSuccess
          block.call(response)
        when Net::HTTPRedirection
          request response['location'] do |response|
            block.call(response)
          end
        else
          response.error!
        end
      end
    end
  end
end

module Rack
  class Response

    def self.build(response)
      headers = {
        'Content-Type' => response.content_type
      }.merge!(response.options)
      content = [response.content.to_s]

      new(response.status_code, headers, content)
    end

    def output
      [@status_code, @headers, @content]
    end

    private

    def initialize(status_code, headers, content)
      @status_code = status_code
      @headers = headers
      @content = content
    end
  end
end

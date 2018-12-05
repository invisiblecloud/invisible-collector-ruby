module InvisibleCollector
  class Response
    attr_reader :content

    def initialize(response, content)
      @success = response.success?
      @content = content
    end

    #
    # true if the request failed for some reason
    #
    def error?
      !@success
    end

    #
    # Returns the content of the response if the request was successful otherwise return +nil+.
    # <tt>response.presence</tt> is equivalent to
    #
    #    response.present? ? response.content : nil
    #
    # @return Depends on the actual request made.
    def presence
      @content if success?
    end

    #
    # true if the request was executed successfully
    #
    def success?
      @success
    end
  end
end

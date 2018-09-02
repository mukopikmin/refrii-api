class HttpError
  def initialize(status, message = nil)
    @status = self.class.numeric_status(status)
    @message = message

    if message.nil?
      case status
      when :bad_request
        @message = 'Bad request'
      when :unauthorized
        @message = 'This action needs authorization'
      when :forbidden
        @message = 'This actions is not allowed'
      when :not_found
        @message = 'Not found'
      when :internal_server_error
        @message = 'Internal server error'
      end
    end
  end

  def self.numeric_status(status)
    status.class == Symbol ? Rack::Utils::SYMBOL_TO_STATUS_CODE[status] : status
  end
end
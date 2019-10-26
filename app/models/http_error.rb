# frozen_string_literal: true

class HttpError
  include ActiveModel::Serialization

  attr_reader :status,
              :message

  DEFAULT_MESSAGE = {
    bad_request: 'Bad request',
    unauthorized: 'This action needs authorization',
    forbidden: 'This actions is not allowed',
    not_found: 'Not found',
    internal_server_error: 'Internal server error'
  }.freeze

  def initialize(status, message = nil)
    @status = self.class.numeric_status(status)
    @message = message || DEFAULT_MESSAGE[status]
  end

  def self.numeric_status(status)
    status.class == Symbol ? Rack::Utils::SYMBOL_TO_STATUS_CODE[status] : status
  end

  def self.model_name
    self.class
  end
end

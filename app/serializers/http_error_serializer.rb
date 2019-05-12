# frozen_string_literal: true

class HttpErrorSerializer < ApplicationRecordSerializer
  attributes :status,
             :message
end

# frozen_string_literal: true

class ApplicationRecordSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
end

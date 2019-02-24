# frozen_string_literal: true

class HttpErrorSerializer < ActiveModel::Serializer
  attributes :status,
             :message
end

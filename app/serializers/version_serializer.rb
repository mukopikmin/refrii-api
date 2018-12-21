# frozen_string_literal: true

class VersionSerializer < ActiveModel::Serializer
  attributes :id,
             :item_id,
             :event,
             :created_at,
             :changes,
             :updated_user

  def changes
    YAML.load(object.object_changes)
  end

  def updated_user
    object.whodunnit.blank? ? nil : UserSerializer.new(User.find(object.whodunnit))
  end
end

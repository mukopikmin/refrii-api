# frozen_string_literal: true

class VersionSerializer < ActiveModel::Serializer
  attributes :id,
             :item_id,
             :event,
             :created_at,
             :changes,
             :updated_user

  def changes
    YAML.safe_load(object.object_changes, [Date, Time], [], true)
  end

  def updated_user
    object.whodunnit.blank? ? nil : UserSerializer.new(User.find(object.whodunnit))
  end
end

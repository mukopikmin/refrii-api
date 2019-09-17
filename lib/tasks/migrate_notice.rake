# frozen_string_literal: true

FILENAME = 'food_notice_migrate.yml'

namespace :migrate do
  namespace :notice do
    desc 'Data migration for table migration of 20190916144218_create_notices'
    task export: :environment do
      YAML.dump(Food.all.map(&:attributes), File.open(FILENAME, 'w'))
    end

    desc 'Data migration for table migration of 20190916144218_create_notices'
    task import: :environment do
      YAML.safe_load(File.open(FILENAME, 'r'), [Date, Time, ActiveSupport::TimeZone, ActiveSupport::TimeWithZone], [], true).map do |food|
        Notice.transaction do
          Notice.create(food_id: food['id'], text: food['notice'])
        end
      end
    end
  end
end

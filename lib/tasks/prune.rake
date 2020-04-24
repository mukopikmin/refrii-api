# frozen_string_literal: true

desc 'Remove record with non existing foreign key'
task prune: :environment do
  logger = Logger.new(STDOUT)

  Notice.all.each do |notice|
    if notice.food.nil?
      logger.info "Remove notice with id #{notice.id}."
      notice.destroy
    end
  end
end

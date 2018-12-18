# frozen_string_literal: true

10.times do |i|
  User.create(name: FFaker::Name.name,
              email: "test#{i}@test.com",
              password: 'password',
              password_confirmation: 'password')
end

20.times do
  Box.create(name: FFaker::Book.title,
             notice: FFaker::Lorem.paragraph,
             owner: User.find(rand(User.first.id .. User.last.id)))
end

User.all.each do |user|
  %w[g pieces packs].each do |label|
    Unit.create(label: label,
                user: user)
  end

  Invitation.new(user: user,
                 box: Box.find(rand(Box.first.id .. Box.last.id)))
end

100.times do
  box = Box.find(rand(Box.first.id..Box.last.id))
  Food.create(name: FFaker::Food.fruit,
              notice: FFaker::BaconIpsum.phrase,
              amount: Random.rand(100.0).round(1),
              expiration_date: Random.rand(Time.zone.tomorrow..Time.zone.tomorrow.next_year),
              box: box,
              unit: Unit.find(rand(box.owner.units.first.id..box.owner.units.last.id)),
              created_user: box.owner,
              updated_user: box.owner)
end

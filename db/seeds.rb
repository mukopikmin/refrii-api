# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create({
  name: 'Test User',
  email: 'test@test.com',
  admin: true,
  password: 'password',
  password_confirmation: 'password'
})

10.times do
  password = FFaker::Internet.password
  User.create({
    name: FFaker::Name.name,
    email: FFaker::Internet.email,
    admin: false,
    password: password,
    password_confirmation: password
  })
end

20.times do
  Box.create({
    name: FFaker::Book.title,
    notice: FFaker::Lorem.paragraph,
    owner: User.find(rand(User.first.id .. User.last.id))
  })
end

40.times do
  Room.create({
    name: FFaker::Book.genre,
    notice: FFaker::Lorem.phrase,
    box: Box.find(rand(Box.first.id .. Box.last.id))
  })
end

100.times do
  Food.create({
    name: FFaker::Food.fruit,
    notice: FFaker::BaconIpsum.phrase,
    amount: Random.rand(100.0),
    expiration_date: Random.rand(Time.zone.tomorrow..Time.zone.tomorrow.next_year),
    room: Room.find(rand(Room.first.id .. Room.last.id))
  })
end

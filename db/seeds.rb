# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create!([
  {
    name: 'test user',
    email: 'test@test.com',
    password: 'password',
    password_confirmation: 'password'
  }
])

boxes = Box.create!([
  {
    name: 'main',
    notice: 'nothing',
    owner: users.first
  }
])

rooms = Room.create!([
  {
    name: 'main',
    notice: 'nothing',
    box: boxes.first
  }
])

foods = Food.create!([
  {
    name: 'main',
    notice: 'nothing',
    amount: 0.5,
    expiration_date: Date.today,
    room: rooms.first
  }
])

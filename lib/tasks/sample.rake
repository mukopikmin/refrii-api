# frozen_string_literal: true

namespace :sample do
  desc 'Create relatins to development user'
  task register: :environment do
    user = User.find_by(email: 'mukopikmin@gmail.com')
    user = User.create(name: '開発者', email: 'mukopikmin@gmail.com') if user.nil?
    user.name = '開発者'
    user.avatar.attach(io: File.open('spec/resources/avatar1.jpg'),
                       filename: 'avatar4.jpg')
    user.save

    Box.all.each do |box|
      Invitation.create(box: box, user: user)
    end

    box = Box.create(name: 'お菓子', owner: user)

    pack = Unit.create(label: 'パック', user: user)
    hon = Unit.create(label: '本', user: user)
    ko = Unit.create(label: '個', user: user)

    tomorrow = Time.zone.tomorrow
    next_month = tomorrow.next_month

    Food.create(name: 'ポテトチップス',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: box,
                unit: pack,
                created_user: user,
                updated_user: user)
    Food.create(name: 'チョコ',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: box,
                unit: ko,
                created_user: user,
                updated_user: user)
    Food.create(name: 'あめ玉',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: box,
                unit: pack,
                created_user: user,
                updated_user: user)
    Food.create(name: 'ジュース',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: box,
                unit: hon,
                created_user: user,
                updated_user: user)
  end

  desc 'Register sample data'
  task create: :environment do
    mother = User.create(name: 'お母さん', email: 'mother@example.com')
    father = User.create(name: 'お父さん', email: 'father@example.com')
    grandma = User.create(name: 'おばあちゃん', email: 'grandma@example.com')

    mother.avatar.attach(io: File.open('spec/resources/avatar1.jpg'),
                         filename: 'avatar2.jpg')
    father.avatar.attach(io: File.open('spec/resources/avatar2.jpg'),
                         filename: 'avatar1.jpg')
    grandma.avatar.attach(io: File.open('spec/resources/avatar3.jpg'),
                          filename: 'avatar3.jpg')

    mother.save
    father.save
    grandma.save

    cold = Box.create(name: '冷蔵庫', owner: mother)
    frozen = Box.create(name: '冷凍庫', owner: mother)
    cooked = Box.create(name: 'つくりおき', owner: grandma)

    Invitation.create(box: cold, user: father)
    Invitation.create(box: frozen, user: father)
    Invitation.create(box: cooked, user: mother)
    Invitation.create(box: cooked, user: father)

    g = Unit.create(label: 'g', user: mother)
    pack = Unit.create(label: 'パック', user: mother)
    hon = Unit.create(label: '本', user: mother)
    ko = Unit.create(label: '個', user: mother)
    shoku = Unit.create(label: '食', user: grandma)

    tomorrow = Time.zone.tomorrow
    next_month = tomorrow.next_month

    Food.create(name: 'にんじん',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cold,
                unit: hon,
                created_user: mother,
                updated_user: mother)
    Food.create(name: 'キャベツ',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cold,
                unit: ko,
                created_user: mother,
                updated_user: mother)
    Food.create(name: 'じゃがいも',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cold,
                unit: ko,
                created_user: mother,
                updated_user: mother)
    Food.create(name: '牛乳',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cold,
                unit: hon,
                created_user: mother,
                updated_user: mother)
    Food.create(name: '牛肉',
                amount: 300,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cold,
                unit: g,
                created_user: mother,
                updated_user: mother)
    Food.create(name: '豆腐',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cold,
                unit: pack,
                created_user: mother,
                updated_user: mother)
    Food.create(name: 'たまご',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cold,
                unit: ko,
                created_user: mother,
                updated_user: mother)
    Food.create(name: 'アイスクリーム',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: frozen,
                unit: ko,
                created_user: mother,
                updated_user: mother)
    Food.create(name: '缶ビール',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: frozen,
                unit: hon,
                created_user: mother,
                updated_user: mother)
    Food.create(name: '冷凍ごはん',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: frozen,
                unit: pack,
                created_user: mother,
                updated_user: mother)
    Food.create(name: '冷凍ミックスベジタブル',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: frozen,
                unit: pack,
                created_user: mother,
                updated_user: mother)
    Food.create(name: '冷凍ぎょうざ',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: frozen,
                unit: pack,
                created_user: mother,
                updated_user: mother)
    Food.create(name: '冷凍うどん',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: frozen,
                unit: pack,
                created_user: grandma,
                updated_user: grandma)

    Food.create(name: '肉じゃが',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cooked,
                unit: shoku,
                created_user: grandma,
                updated_user: grandma)
    Food.create(name: 'みそ汁',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cooked,
                unit: shoku,
                created_user: grandma,
                updated_user: grandma)
    Food.create(name: 'コロッケ',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cooked,
                unit: ko,
                created_user: grandma,
                updated_user: grandma)
    Food.create(name: 'ホットケーキ',
                amount: 3,
                expiration_date: Random.rand(tomorrow..next_month),
                box: cooked,
                unit: ko,
                created_user: grandma,
                updated_user: grandma)

    20.times do
      food = Food.find(rand(Food.first.id..Food.last.id))
      Notice.create(text: FFaker::BaconIpsum.phrase,
                    food: food,
                    created_user: food.box.owner,
                    updated_user: food.box.owner)
    end
  end
end

require 'faker'

users = []
pet_rooms = []
dogs = []
cats = []

sizes = ["Small", "Medium", "Large"]

user_test = User.create( name: 'Test',
  email: 'test@mail.com',
  password: 'user123',
  jti: SecureRandom.uuid )

user_test.save!

3.times do
  pet_room = PetRoom.create( name: Faker::Lorem.word.capitalize + " Room",
                              type_of_pet: "Dog",
                              max_size_accepted: "Small",
                              rating: [4, 5, 4, 5, 4],
                              price: 100,
                              user_id: user_test.id
                            )
  pet_rooms << pet_room
end

3.times do
  dog = user_test.pets.create( name: Faker::Creature::Dog.name,
                                pet_type: "dog",
                                date_of_birth: Faker::Date.birthday(min_age: 1, max_age: 18),
                                size: sizes.sample,
                                allergies: "none",
                                extra_information: "none",
                                breed: Faker::Creature::Dog.breed,
                                gender: Faker::Creature::Dog.gender,
                                hair_length: Faker::Creature::Dog.coat_length,
                                user_id: user_test.id
                              )
  dog.image.attach(io: File.open("#{Rails.root}/app/assets/pet_images/dog#{rand(1..10)}.jpg"), filename: "dog#{rand(1..10)}.jpg")
end

2.times do
  cat = user_test.pets.create( name: Faker::Creature::Cat.name,
                                pet_type: "cat",
                                date_of_birth: Faker::Date.birthday(min_age: 1, max_age: 18),
                                size: "small",
                                allergies: "none",
                                extra_information: "none",
                                breed: Faker::Creature::Cat.breed,
                                gender: Faker::Creature::Dog.gender,
                                hair_length: Faker::Creature::Dog.coat_length,
                                user_id: user_test.id
                              )
  cat.image.attach(io: File.open("#{Rails.root}/app/assets/pet_images/cat#{rand(1..5)}.jpg"), filename: "cat#{rand(1..5)}.jpg")
end

5.times do
  user = User.create( name: Faker::Name.name,
                      email: Faker::Internet.email,
                      password: 'user123',
                      jti: SecureRandom.uuid )
  users << user

  2.times do
    pet_rooms << user.pet_rooms.create( name: Faker::Lorem.word.capitalize + " Room",
                                          type_of_pet: "Dog",
                                          max_size_accepted: "Small",
                                          rating: [4, 5, 4, 5, 4],
                                          price: 100,
                                          user_id: user.id
                                        )
  end

  2.times do
    dogs << user.pets.create( name: Faker::Creature::Dog.name,
                                pet_type: "dog",
                                date_of_birth: Faker::Date.birthday(min_age: 1, max_age: 18),
                                size: sizes.sample,
                                allergies: "none",
                                extra_information: "none",
                                breed: Faker::Creature::Dog.breed,
                                gender: Faker::Creature::Dog.gender,
                                hair_length: Faker::Creature::Dog.coat_length,
                                user_id: user.id
                              )
  end

  cats << user.pets.create( name: Faker::Creature::Cat.name,
                              pet_type: "cat",
                              date_of_birth: Faker::Date.birthday(min_age: 1, max_age: 18),
                              size: "small",
                              allergies: "none",
                              extra_information: "none",
                              breed: Faker::Creature::Cat.breed,
                              gender: Faker::Creature::Dog.gender,
                              hair_length: Faker::Creature::Dog.coat_length,
                              user_id: user.id
                            )
end

(users + [user_test]).each do |user|
  Reservation.create( start_date: Faker::Date.between(from: 2.days.ago, to: Date.today),
                      end_date: Faker::Date.between(from: Date.today, to: 2.days.from_now),
                      pet_id: user.pets.first.id,
                      pet_room_id: pet_rooms.sample.id,
                      user_id: user.id
                    )
end

# Dogs
i = 0
10.times do
  the_pet = dogs[i]
  the_pet.image.attach(io: File.open("#{Rails.root}/app/assets/pet_images/dog#{i+1}.jpg"), filename: "dog#{i+1}.jpg")
  i += 1
end

# Cats
i = 0
5.times do
  the_pet = cats[i]
  the_pet.image.attach(io: File.open("#{Rails.root}/app/assets/pet_images/cat#{i+1}.jpg"), filename: "cat#{i+1}.jpg")
  i += 1
end

# Pet Rooms
pet_rooms.each_with_index do |pet_room, index|
  file_index = index % 11 + 1
  file_path = "#{Rails.root}/app/assets/pet_rooms/petRoom#{file_index}.jpg"
  if File.exist?(file_path)
    pet_room.image.attach(io: File.open(file_path), filename: "petRoom#{file_index}.jpg")
  else
    puts "File #{file_path} does not exist."
  end
end

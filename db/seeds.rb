# coding: utf-8

User.create!( name: "管理者",
              email: "sample@email.com",
              password: "password",
              password_confirmation: "password",
              admin: true)
              

99.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

admin_user = User.first
gust_user_a =  User.find(2)
gust_user_b =  User.find(3)
50.times do |n|
  task_name = "タスク#{n + 1}"
  description = "タスク詳細#{n + 1}"
  admin_user.tasks.create!(name: task_name, description: description)
  gust_user_a.tasks.create!(name: task_name, description: description)
  gust_user_b.tasks.create!(name: task_name, description: description)
end

puts "Tasks Created"

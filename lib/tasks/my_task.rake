namespace :my_task do
  desc "TODO"
  task join: :environment do #지금 이 SNS에는 40명의 사용자(20대 20명, 30대 10명, 40대 5명, 50대 5명)가 가입한 상태다.
  i=0
   for i in 1..20
      User.create name: Faker::Name.first_name, phone: Faker::PhoneNumber.phone_number, age: rand(20..29)
      
      if i<=10
        User.create name: Faker::Name.first_name, phone: Faker::PhoneNumber.phone_number, age: rand(30..39)
      end
      
      if i<=5 
        User.create name: Faker::Name.first_name, phone: Faker::PhoneNumber.phone_number, age: rand(40..49)
        User.create name: Faker::Name.first_name, phone: Faker::PhoneNumber.phone_number, age: rand(50..59)
      end
   end
  end
  
  desc "TODO"
  task posting: :environment do #50대 회원은 1인당 1개의 게시물을 작성했고,
    j=0
    for j in 1..40
      if User.find(j).age>=50 
        Post.create title: Faker::Beer.name, content: Faker::Beer.style, user_id: User.find(j).id
      end
    end
  end
  
  desc "TODO"
  task commenting: :environment do #50대 회원은 1인당 1개의 게시물을 작성했고,
    k=0
    for k in 1..40
      if User.find(k).age>=40&&User.find(k).age<50
        Comment.create content: Faker::Beer.alcohol, post_id: rand(1..2), user_id: User.find(k).id
      end
    end
  end
  
end

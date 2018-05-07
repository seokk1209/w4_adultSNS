# 구현 목표
  본 과제의 목표는 멋쟁이 사자처럼 정규 수업시간에 배운 DataBase 개념과 더불어
  Validation, Rake, Task 개념을 종합적으로 활용하여
  실제 DB 모델을 조건에 따라 구축하는 것이다.
  
# 모델 속성 표

### User 속성 표
| Id     | Name   | Phone  | Age    | Created at| Updated at|
|--------|--------|--------|--------|-----------|-----------|
### Post 속성 표
| Id     | Title  | Content| User_id| Created at| Updated at|
|--------|--------|--------|--------|-----------|-----------|
### Comment 속성 표
| Id     | content| Post_id| User_id| Created at| Updated at|
|--------|--------|--------|--------|-----------|-----------|

# 각각 모델 코드(User.rb..)

### User.rb
    class User < ApplicationRecord
        has_many :posts #사용자는 다수의 게시물(post)를 작성할수 있고,
        has_many :comments #사용자들은 게시물에 다수의 댓글(comment)을 작성할수 있다.


        validates :name, length: {maximum: 10} #사용자의 이름은 10자까지 가능하다.
        validates :phone, format: { with: /\d[0-9]\)*\z/} #사용자의 전화번호는 반드시 전화번호 형식을 갖춰야 한다.(정규표현식)
        validates :age, :numericality => { greater_than: 19 } #19세 이하의 사용자는 가입할수 없다.

    end

- - -

### Post.rb
    class Post < ApplicationRecord
        belongs_to :user #사용자는 다수의 게시물(post)를 작성할수 있고,
        has_many :comments #코멘트는 게시글에 종속된다.

        words = ["fuck","shit","bitch"]


        before_save{ #댓글과 게시글에는 욕설(fuck,shit,bitch)이 들어가면 *를 글자수만큼 필터링해준다.
            words.each do |word|
                len = word.length
                self.content.gsub!(/#{word}/, '*'*len) if(self.content.include?(word))
            end
        }

    end
### comment.rb
    class Comment < ApplicationRecord
      belongs_to :post #코멘트는 게시글에 종속된다
      belongs_to :user #사용자들은 게시물에 다수의 댓글(comment)을 작성할수 있다.

        words = ["fuck","shit","bitch"]
        before_save{ #댓글과 게시글에는 욕설(fuck,shit,bitch)이 들어가면 *를 글자수만큼 필터링해준다.
            words.each do |word|
                len = word.length
                self.content.gsub!(/#{word}/, '*'*len) if(self.content.include?(word))
            end
        }

        validates :content, length: {maximum: 100} #댓글의 길이는 100자 이내이다.

    end

# Schema.rb
    ActiveRecord::Schema.define(version: 20180507131030) do

      create_table "comments", force: :cascade do |t|
        t.text     "content"
        t.integer  "post_id"
        t.string   "user_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["post_id"], name: "index_comments_on_post_id"
      end

      create_table "posts", force: :cascade do |t|
        t.text     "title"
        t.text     "content"
        t.string   "user_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end

      create_table "users", force: :cascade do |t|
        t.string   "name"
        t.string   "phone"
        t.integer  "age"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end

    end
# .task 파일
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

# 오류 내용 + 오류 해결과정(코드첨부)
    1. 정규화 과정에서 다른 phone number를 정규화하는 것이 이상했다. 인터넷에서 찾은 코드가 처음에는 /^\d{3}-\d{3,4}-\d{4}$/; 이 코드였는데, Faker에서 뱉어주는 phone number의 형태가 굉장히 광범위했다..... 수많은 코드를 찾아보고 직접 만들어보려고도 하였으나 실패하고 결국 찾은 코드가 /\d[0-9]\)*\z/ 였다. 이에 대한 이해가 생기면 참 좋을것 같은데 따로 정규화코드에 대한 공부가 필요할 것 같다.
----
    2. 반복문을 통해서 User 를 생성하는 코드를 task 상에 만들면서 이게 될까? 하는 생각이 많이 들었다. 그래서 rails 콘솔을 켜두고 하나씩 코드를 넣어보며 실제 DB 튜플이 생성되는지 여러번 시험해 본 결과 
  	 User.create name: Faker::Name.first_name, phone: Faker::PhoneNumber.phone_number, age: rand(20..29) 이런 코드를 만들어 낼 수 있었다.
     그런데 (20..29).sample 을 하면 수 하나를 임의로 받아온다고 생각했는데 이게 안되더라... 왜인지는 아직 원인을 규명하지 못했다...
-------
     3. 이부분은 오류라기 보다는 개인적인 생각에서 모델을 조금 더 구체화 시킨 부분이다.
     요구사항에서는 user_id로 comments 를 식별하는 내용이 담겨있지 않았으나, 개개인적으로 어떤 사람이 post에 대한 comment를 했는지를 구별하고 싶었다. 그래서 belongs_to :user 코드를 comment에 추가시키고 comment 에도 user_id 속성을 추가하여서 comment를 단 user 가 누군지도 확인할 수 있도록 하였다.
------     

# 느낀점 
아직도 너무너무 어렵다... 오늘은 정오(12)시부터 꼬박 12시간을 4주차 강의공부에 사용한 듯 하다.....
혼자 posting 형태로 강의안을 정리하면서 하니까 이해도가 깊어지는것 같다... 물론 아직도 어렵지만.
db 에 관련해서는 이제 조금 나아진듯 싶다... 다시 html css 부분도...정리해야할텐데...


# 참고문서 링크
 - https://github.com/stympy/faker/blob/master/doc/book.md
 - https://rubykr.github.io/rails_guides/
 - https://opentutorials.org/module/517/4590
 - http://www.xyzpub.com/en/ruby-on-rails/3.2/activerecord_validation.html
 - https://guides.rorlab.org/active_record_validations.html
 - https://stackoverflow.com/questions/10515381/validating-the-phone-number-with-a-regex-ruby?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
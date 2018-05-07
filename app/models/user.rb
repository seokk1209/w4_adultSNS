class User < ApplicationRecord
    has_many :posts #사용자는 다수의 게시물(post)를 작성할수 있고,
    has_many :comments #사용자들은 게시물에 다수의 댓글(comment)을 작성할수 있다.
    
    
    validates :name, length: {maximum: 10} #사용자의 이름은 10자까지 가능하다.
    validates :phone, format: { with: /\d[0-9]\)*\z/} #사용자의 전화번호는 반드시 전화번호 형식을 갖춰야 한다.(정규표현식)
    validates :age, :numericality => { greater_than: 19 } #19세 이하의 사용자는 가입할수 없다.
    
end

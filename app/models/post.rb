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

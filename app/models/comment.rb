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

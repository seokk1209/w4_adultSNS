class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    #사용자 정보에는 이름(name), 전화번호(phone), 나이(age) 등이 있다.
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.integer :age

      t.timestamps
    end
  end
end

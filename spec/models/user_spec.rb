require 'rails_helper'

RSpec.describe User, type: :model do
  it 'メールアドレス,パスワードがある場合有効であり、デフォルトでroleはotherである' do
    user = User.create(email: 'test@example.com', password: '12345', password_confirmation: '12345' )
    expect(user).to be_valid
    expect(user.role).to eq('other') 
  end
  describe 'メールアドレス' do
    it 'メールアドレスがない場合無効である' do
      user = User.new(email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end
  
    it '重複したメールアドレスの場合、無効である' do
    user1 = create(:user, :same_email)
    user2 = build(:user, :same_email)
    user2.valid?
    expect(user2.errors[:email]).to include("has already been taken") 
  end
  end

  describe 'パスワード' do
    it 'パスワードが空の場合無効である' do
      user = build(:user, :no_password)
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 5 characters)")
    end

    it 'パスワードは5文字以上でなければならない' do
      user = build(:user, :password_short)
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 5 characters)")
    end

    it 'password_confirmationが空の場合無効である' do
      user = build(:user, :no_password_confirmation)
      user.valid?
      expect(user.errors[:password_confirmation]).to include("can't be blank")
    end

    it 'passwordとpassword_confirmationの内容が違う場合無効である' do
      user = build(:user, :deferent_password_confirmation)
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end
  
  
  
  # t.string :email, null: false unique ok
  # t.integer :role, default: 0 ok
  # validates :password, length: { minimum: 5 }, if: -> { new_record? || changes[:crypted_password] } ok
  # validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] } ok
  # validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] } ok

  # enum role: {other: 0, admin: 1}ok
end

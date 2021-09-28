require 'rails_helper'

RSpec.describe Member, type: :model do
  xit 'nameが入力されている場合成功する' do
    member = Member.create(name: 'test')
    expect(member).to be_valid
  end

  xit 'nameがない場合無効である' do
     member = Member.new(name: nil)
     member.valid?
     expect(member.errors[:name]).to include("can't be blank")
  end

  xit 'nameは一意である' do
    member1 = create(:member_same_name)
    member2 = build(:member_same_name)
    member2.valid?
    expect(member2.errors[:name]).to include("has already been taken") 
  end

  describe "dependent: :destroy" do
    let!(:member_1) {create(:member) }
    let!(:member_2) {create(:member) }
    it 'dependent: :destroy' do
      expect{
      member_1.destroy
      }.to change{Member.count}.by(-1).and change{ArticleMember.count}.by(-1)
    end
  end

  # t.string :name, null: false, unique: true ok○
  # has_many :article_members, dependent: :destroy　ここだけ

end

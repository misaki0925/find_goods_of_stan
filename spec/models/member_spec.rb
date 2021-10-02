require 'rails_helper'
RSpec.describe Member, type: :model do
  it 'nameが入力されている場合成功する' do
    member = Member.create(name: 'test')
    expect(member).to be_valid
  end

  it 'nameがない場合無効である' do
    member = Member.new(name: nil)
    member.valid?
    expect(member.errors[:name]).to include(I18n.t('errors.messages.blank'))
  end

  it 'nameは一意である' do
    member1 = create(:member_same_name)
    member2 = build(:member_same_name)
    member2.valid?
    expect(member2.errors[:name]).to include(I18n.t('errors.messages.taken')) 
  end

  describe "dependent: :destroyが有効か" do
    let!(:member_1) {create(:member, :with_article)}
    let!(:member_2) {create(:member, :with_article)}
    it 'Memberを削除したらArticleMemberも削除される' do
      expect{
      member_1.destroy
      }.to change{Member.count}.by(-1).and change{ArticleMember.count}.by(-1)
    end
  end
end

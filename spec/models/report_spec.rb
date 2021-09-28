require 'rails_helper'

RSpec.describe Report, type: :model do
  it 'コメントが入力されている場合成功する' do
    report = Report.create(comment: 'test_test')
    expect(report).to be_valid  
  end
  
  it 'コメントが入力されていない場合報告に失敗する' do
    report = Report.new(comment: '')
    report.valid?
    expect(report.errors[:comment]).to include("can't be blank") 
  end
end

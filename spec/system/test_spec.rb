require 'rails_helper'

RSpec.describe 'AdiminsArticle', type: :system  do
  describe "Twitterapiの部分のみテスト" do
    let(:response_body) { {text: "SixTONES
      YouTube - ASMR!?音を立てずに食リポできるか選手権 他
      
      松村北斗さん着用
      
      【クレヨンしんちゃん】
      Mクルーソックスひろしの靴下
      white
      ¥638- tax in
      
      ※HP画像使わせて頂きました

      #Hokuto_Six衣装"}}

    it 'ネストさせちゃう' do
      
      allow(Article).to receive_message_chain('search_client.search.take.each').and_return(response_body)
      expect(Article.search_tweets).to eq response_body
    
      byebug
    end
  end
  

  describe "Twitterapiの部分のみテスト" do
    let(:response_body) { [ {text: "京本大我"}, {text: "松村北斗"} ] }
    before do
      twitter_client_mock = double('Twitter_client')
      respomce_mock = double('respomce_mock', body: response_body)
      allow(Article).to receive_message_chain('search_client.search.take.each').and_return([respomce_mock])
    end
    xit 'ネストさせちゃう' do
      expect(Article.search_tweets).to eq '京本大我さん'
    end
  end

end
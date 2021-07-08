Rails.application.routes.draw do
  post '/callback' => 'linebot#callback'
  post '/callback0' => 'linebot#callback'
end

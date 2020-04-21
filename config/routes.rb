Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/swagger'
  root 'point_of_sales#index'

  get '/point-of-sale/:id', to: 'point_of_sales#get'
  get '/point-of-sale', to: 'point_of_sales#search'
  post '/point-of-sale', to: 'point_of_sales#create'
end

Rails.application.routes.draw do

  root 'point_of_sales#index'

  get '/pos/:id', to: 'point_of_sales#get'
  get '/pos', to: 'point_of_sales#search'
  post '/pos', to: 'point_of_sales#create'
end

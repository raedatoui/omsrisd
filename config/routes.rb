Risd::Application.routes.draw do

  mount OMS::Engine => "/oms"

  get '/interests/:id/:slug' => 'page#node'

  root to: "page#index"

end

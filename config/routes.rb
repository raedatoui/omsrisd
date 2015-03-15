Risd::Application.routes.draw do

  mount OMS::Engine => "/oms"

  get '/:token/:id/:slug' => 'page#node'

  root to: "page#index"

end

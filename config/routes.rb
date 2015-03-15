Risd::Application.routes.draw do

  mount OMS::Engine => "/oms"

  root to: "page#index"

end

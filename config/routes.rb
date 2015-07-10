AdwordsOnRails::Application.routes.draw do
  get "queries/index"

  get "queries/new"

  get "queries/show"

  get "home/index"

  get "campaign/index"

  get "account/index"
  get "account/input"
  get "account/select"

  get "login/prompt"
  get "login/callback"
  get "login/logout"

  get "queries/index"
  get "queries/new"
  get "queries/show"

  get "report/index"
  post "report/get"

  root :to => "home#index"
end

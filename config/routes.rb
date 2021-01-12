Rails.application.routes.draw do
  post "user_token" => "user_token#create"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #namespace 'api' do
  #  namespace 'v1' do
  #    resources :posts
  #    resources :users
  #   end
  #end
  #Complaints
  get "complaints", to: "complaints#allComplaints"
  post "complaintsPerPage/page/:page/limit/:limit", to: "complaints#complaintsPerPage"
  get "complaintsPerDates/page/:page/limit/:limit/dateFrom/:dateFrom/dateTo/:dateTo", to: "complaints#complaintsPerDates"

  #get 'complaint/get/:id', to: 'complaints#complaintById'
  post "complaint/get/:id", to: "complaints#complaintById"

  post "complaint/generate", to: "complaints#newComplaint"
  post "complaint/update", to: "complaints#updateComplaintById"
  get "sendEmail", to: "complaints#sendEmail"
  #Stores
  get "stores", to: "stores#getAllStores"
  #RelStoreSupervisors
  post "supervisors/get_by/store", to: "stores#getSupervisorsByStore"

  #categoriesComplaint
  get "categoriesComplaint", to: "categories_complaint#allCategoriesComplaint"
  #importanceLevels
  get "importanceLevels", to: "importance_levels#allImportanceLevels"
  #issues
  post "issue/generate", to: "issues#newIssue"
  get "issues", to: "issues#allIssues"
  post "issue/get/:id", to: "issues#issueById"
  post "issue/update", to: "issues#updateIssueById"
  #auth
  get "authLevel", to: "auth_level#allAuthLevels"
  #users
  get "users", to: "users#allUsers"
  post "user/get_by/email", to: "users#getUserByEmail"
  post "user/generate", to: "users#newUserAccount"
  post "user/create", to: "users#create"
  get "user/get/:id", to: "users#userById"
  post "user/update", to: "users#updateUserAccountById"
  post "user/password/update", to: "users#updatePasswordsAccountById"

  #menu
  #get 'appmenu', to: 'app_nav_menu_options#index'
  post "appmenu", to: "app_nav_menu_options#getMenu"
  #helper..
  #get 'datetoyear', to: 'complaints#dateToOperativeDay'

end

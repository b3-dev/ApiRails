Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #namespace 'api' do
  #  namespace 'v1' do
  #    resources :posts
  #    resources :users
  #   end
  #end
#Complaints
get 'complaints', to: 'complaints#allComplaints'
get 'complaint/get/:id', to: 'complaints#complaintById'
post 'complaint/generate', to: 'complaints#newComplaint'
post 'complaint/update', to: 'complaints#updateComplaintById'
get 'sendEmail', to: 'complaints#sendEmail'
#Stores
get 'stores', to: 'stores#getAllStores'
#RelStoreSupervisors
post 'supervisors/get_by/store', to: 'stores#getSupervisorsByStore'

#categoriesComplaint
get 'categoriesComplaint', to: 'categories_complaint#allCategoriesComplaint'
#importanceLevels
get 'importanceLevels', to:'importance_levels#allImportanceLevels'
#issues
post 'issue/generate', to: 'issues#newIssue'
get 'issues', to: 'issues#allIssues'
#users
get 'users', to: 'users#index'
post 'user/get_by/email', to: 'users#getUserByEmail'
#menu
#get 'appmenu', to: 'app_nav_menu_options#index'
get 'appmenu', to: 'app_nav_menu_options#getMenu'
#helper..
#get 'datetoyear', to: 'complaints#dateToOperativeDay'

end

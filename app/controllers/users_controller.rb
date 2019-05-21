class UsersController < ApplicationController
    #verify if the user is logged by knock
    before_action :authenticate_user, only: [:index, :getUserByEmail]

    def index 
        render json: {status: 200, msg: 'Autenticado'}
    end
    

    def getUserByEmail
        data =  request.raw_post
        data_parsed = JSON.parse(data)
        #KNOCK GETS THE USER BY TOKEN PASSED, USING THE EMAIL EMBEBED ON AUTH ARRAY. 
        #THIS IS LIKE THE LOGIN METHOD
        user = User.from_token_request data_parsed
        defaultScreen =  AppRelParentChildMenu.select(:description_child_screen_menu, :route_child_screen_menu)
        .joins(:AppChildScreenMenu).where(set_default_main_screen_menu: 1)
        render :json => { :user=>user, :defaultScreen=>defaultScreen}
    end

end
  # User.create!(
       #     nomusuario: 'john@doe.com', 
       #     apusuario: 'john@doe.com', 
       #     login: 'john@doe.com', 
       #     email: 'john@doe.com', 
       #     password: '12345',
       #     vigencia: 1,
       #     id_autoridad: 1)
      # user = User.find 2223
       
     #  user.password = '111'
     #  user.save
       
     #  render :json => { :data=>user}

class UsersController < ApplicationController
  #verify if the user is logged by knock
  before_action :authenticate_user, only: [:index, :getUserByEmail, :userById, :newUserAccount, :updateUserAccount]

  def index
    render json: { status: 200, msg: "Autenticado" }
  end

  def allUsers
    arrayUsers = User.select("*")
      .joins(:AuthLevel)
      .order(id_usuario: :asc)
    render :json => { :data => arrayUsers }
  end

  def getUserByEmail
    data = request.raw_post
    data_parsed = JSON.parse(data)
    #KNOCK GETS THE USER BY TOKEN PASSED, USING THE EMAIL EMBEBED ON AUTH ARRAY.
    #THIS IS LIKE THE LOGIN METHOD
    user = User.from_token_request data_parsed
    if user["vigencia"] == 1
      defaultScreen = AppRelParentChildMenu.select(:description_child_screen_menu, :route_child_screen_menu)
        .joins(:AppChildScreenMenu, :AuthLevel)
        .where(set_default_main_screen_menu: 1)
        .where(id_autoridad: user["id_autoridad"])

      if !defaultScreen[0].blank?
        render :json => { :Status => "OK", :user => user, :defaultScreen => defaultScreen }
      else
        render :json => { :Status => "WRONG", :user => user, :defaultScreen => defaultScreen }
      end
    else
      render :json => { :Status => "REFUSED", :user => user, :defaultScreen => defaultScreen }
    end
  end

  def updatePasswordsAccountById
    data = request.raw_post
    rowUser = JSON.parse(data)
    puts "update passwords"
    puts rowUser
    user = User.find_by(id_usuario: rowUser["data"]["userId"])
    #user.nomusuario = rowUser["data"]["fistNameUser"]
    #user.apusuario = rowUser["data"]["lastNameUser"]
    #user.email = rowUser["data"]["email"]
    user.password = rowUser["data"]["NewPassword"]
    user.password_remember = user.password
    user.password_digest_remember = user.password_digest
    # user.id_autoridad = rowUser["data"]["idAuth"]
    update = user.save

    if update
      msg = { :Status => "OK",
             :User => user }

      render :json => { :data => msg }
    else
      msgWrong = { :Status => "ERROR",
                  :User => [] }
      render :json => { :data => msgWrong }
    end
  end

  def updateUserAccountById
    data = request.raw_post
    rowUser = JSON.parse(data)
    user = User.find_by(id_usuario: rowUser["data"]["userId"])
    user.nomusuario = rowUser["data"]["fistNameUser"]
    user.apusuario = rowUser["data"]["lastNameUser"]
    user.email = rowUser["data"]["email"]
    user.password = user["password"]
    user.password_remember = user["password"]
    user.password_digest_remember = user.password_digest
    user.id_autoridad = rowUser["data"]["idAuth"]
    update = user.save

    if update
      msg = { :Status => "OK",
             :User => user }

      render :json => { :data => msg }
    else
      msgWrong = { :Status => "ERROR",
                  :User => [] }
      render :json => { :data => msgWrong }
    end
  end

  def userById
    id = params[:id]
    arrayUser = User.select("*")
      .joins(:AuthLevel)
      .where(id_usuario: id)

    render :json => { :Status => "OK", :data => arrayUser[0] }
  end

  def new
    User.create!(
      nomusuario: "john@doe.com",
      apusuario: "john@doe.com",
      login: "john@doe.com",
      email: "john@doe.com",
      password: "12345",
      vigencia: 1,
      id_autoridad: 1,
    )
  end

  def create
    puts "entrando a create"
    @user = User.create!(user_params)
    @user.errors.full_messages
    @user.save
    @user.errors.full_messages
    if @user.id
      render :json => { :Status => "OK", :user => @user }
    else
      render :json => { :Status => "ERROR", :user => [] }
    end
  end

  def newUserAccount
    data = request.raw_post
    rowUser = JSON.parse(data)

    user = User.create_account rowUser

    #user = User.new
    #user.nomusuario = rowUser["data"]["fistNameUser"]
    #user.apusuario = rowUser["data"]["lastNameUser"]
    #user.login = rowUser["data"]["login"]
    # user.email = rowUser["data"]["email"]
    # user.password_remember = rowUser["data"]["rePass"]
    # user.password = "111"
    # user.password_digest_remember = user.password_digest
    # user.id_autoridad = rowUser["data"]["idAuth"]
    # usr = user.save
    # puts "user aca.."
    # puts usr

    if user
      msg = { :Status => "OK",
             :User => { :id => user } }

      render :json => { :data => msg }
    else
      msgWrong = { :Status => "ERROR",
                  :User => {
        :id => 0,
      } }
      render :json => { :data => msgWrong }
    end
  end

  private

  def user_params
    params[:user].permit(:email, :password, :nomusuario, :id_autoridad)
  end
end #end of class

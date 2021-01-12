class AppNavMenuOptionsController < ApplicationController

  # before_action :authenticate_user, only: [:index]

  def index
    arrayCategories = AppParentCategoryMenu.all.order(sort_category_menu: :asc)
    render json: { status: 200, msg: arrayCategories }
  end

  def getMenu
    data = request.raw_post
    dataUser = JSON.parse(data)
    idAuth = geAuth dataUser
    arrayAppMenu = []
    #User.select(:name).distinctd description_category_menu
    arrayParent = AppRelParentChildMenu.select(:id_parent_category_menu, :description_category_menu)
      .joins(:AppParentCategoryMenu)
      .distinct.where(id_autoridad: idAuth)

    arrayAppMenu = parsingMenu(arrayParent, idAuth)
    render json: { status: 200, menu: arrayAppMenu, auth: idAuth }

    #joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
    # arrayParents = AppRelParentChildMenu.select(:id_parent_category_menu, :description_category_menu).distinct.where(id_autoridad: idAuth)
    #render json: {status: 200, categories: arrayParent}
  end

  def parsingMenu(array, idAuth)
    arrayAppMenu = []
    arrayFullParsed = array.map { |i| { categorie_id: i.id_parent_category_menu, category_name: i.description_category_menu } }
    #array.map returns on collection of categories under format [1,2,3]  changing the json format
    arrayFullParsed.each do |category|
      childs = AppRelParentChildMenu
        .select(:id_app_child_screen_menu,
                :set_default_main_screen_menu,
                :description_child_screen_menu,
                :route_child_screen_menu).joins(:AppChildScreenMenu).where(id_autoridad: idAuth)
        .where(id_parent_category_menu: category[:categorie_id])
        .order(sort_child_screen_menu: :asc)

      arrayAppMenu.push(category: { description_category_menu: category[:category_name], id_parent_category_menu: category[:categorie_id], childs: childs })
    end
    return arrayAppMenu
  end

  def geAuth(dataUser)

    #KNOCK GETS THE USER BY TOKEN PASSED, USING THE EMAIL EMBEBED ON AUTH ARRAY.
    #THIS IS LIKE THE LOGIN METHOD
    user = User.from_token_request dataUser
    return user["id_autoridad"]
  end
end

#render :json => { :data=>arrayStores }

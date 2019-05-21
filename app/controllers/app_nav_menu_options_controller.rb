class AppNavMenuOptionsController < ApplicationController

   # before_action :authenticate_user, only: [:index]
    
    def index 
        arrayCategories = AppParentCategoryMenu.all.order(sort_category_menu: :asc)
        render json: {status: 200, msg: arrayCategories}
    end

    def getMenu 
        idAuth = 2 #
        arrayAppMenu=[]
        #User.select(:name).distinctd description_category_menu
        arrayParent = AppRelParentChildMenu.select(:id_parent_category_menu, :description_category_menu)
              .joins(:AppParentCategoryMenu)
              .distinct.where(id_autoridad:  idAuth)
              
        arrayAppMenu=parsingMenu(arrayParent)
        render json: {status: 200, menu: arrayAppMenu}

        #joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
        # arrayParents = AppRelParentChildMenu.select(:id_parent_category_menu, :description_category_menu).distinct.where(id_autoridad: idAuth)
        #render json: {status: 200, categories: arrayParent}
    end

    def parsingMenu(array)
        #|u| { login: u.login, name: u.name } }
        arrayAppMenu=[]
        arrayFullParsed= array.map {|i|  { categorie_id: i.id_parent_category_menu, category_name: i.description_category_menu} }
        arrayFullParsed.each do |category|
           childs = AppRelParentChildMenu
            .select(:id_app_child_screen_menu,
            :set_default_main_screen_menu,
            :description_child_screen_menu,
            :route_child_screen_menu,
            ).joins(:AppChildScreenMenu).where(id_autoridad: '2')
           .where(id_parent_category_menu: category[:categorie_id] )
           
            
         #   arrayFullParsed['categorie']['id_parent_category_menu'] = (category.id_parent_category_menu).to_s 
            # anotherArray.push(categorie: category[:category_name] )
            arrayAppMenu.push(category: {description_category_menu:category[:category_name], id_parent_category_menu: category[:categorie_id], childs: childs  } )

        end
        return arrayAppMenu
        #render json: {status: 200, menu: anotherArray}
    end
end

#render :json => { :data=>arrayStores } 

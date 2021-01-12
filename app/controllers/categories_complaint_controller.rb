class CategoriesComplaintController < ApplicationController
  def allCategoriesComplaint
    # select("*").order(id_unidad: :asc)
    arrayCategories = CategoryComplaint.select("*")
      .order(id_tipoqueja: :asc)

    render :json => { :data => arrayCategories }
  end
end

class ImportanceLevelsController < ApplicationController
    def allImportanceLevels
        arrayImportance = ImportanceLevel.select("*")
        .order(id_importancia: :asc)

        render :json => { :data=>arrayImportance } 
    end
end

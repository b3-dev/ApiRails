class StoresController < ApplicationController
    before_action :authenticate_user, only: [:getSupervisorsByStore]

    def getAllStores
        arrayStores = Store.select("*").order(id_unidad: :asc)
     # .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
     # .limit(200);
      render :json => { :data=>arrayStores } 
    
    end

    def getSupervisorsByStore
        data = request.raw_post
        dataParsed = JSON.parse(data)
        if dataParsed['data']['store_id'] && dataParsed['data']['store_id']>0
        arraySupervisor = RelStoreSupervisor.select('*')
            .joins(:Supervisor,:Manager)
            .where(id_unidad:dataParsed['data']['store_id'])
        
            render :json => { :data=>arraySupervisor }
        else
            render :json => { :data=>[] }
        end
    end
end

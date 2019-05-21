class IssuesController < ApplicationController
    def newIssue
        time = Time.now
        time.to_formatted_s(:db)    
        information = request.raw_post
        data_parsed = JSON.parse(information)
        
        rowIssue = Issue.new
        rowIssue.id_unidad = data_parsed['data']['store']
        rowIssue.descripcion_solicitudes_asociados = data_parsed['data']['issueDescription']
        rowIssue.fecha_registro_solicitudes_asociados  = time
        rowIssue.fecha_registro_solicitudes_asociados  = time
        rowIssue.id_asociado = 1
        rowIssue.save
        if rowIssue.id 
            msg = { :Status => "OK", 
                :Issue => {:id=> rowIssue.id}, 
            }
           
            render :json => { :data=>msg }
          else
            msgWrong = { :Status => "ERROR", 
                :Issue => {
                    :id=> 0
                }, 
            }
            render :json => { :data=>msgWrong}
        end
    end

    def allIssues
        # arrayComplaints =  Complaint.where(id_tipoqueja: 2)
        arrayIssues = Issue.select("*")
        .joins(:Partner)
       # .limit(200);
        render :json => { :data=>arrayIssues } 
      end
  
end

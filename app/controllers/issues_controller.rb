class IssuesController < ApplicationController
    before_action :authenticate_user, only: [:newIssue, :issueById, :updateIssueById]

    def newIssue
        time = Time.now
        time.to_formatted_s(:db)    
        rowIssue = Issue.new
        data = request.raw_post
        data_parsed = JSON.parse(data)
        rowIssue.id_unidad = data_parsed['data']['store']
        rowIssue.descripcion_solicitudes_asociados = data_parsed['data']['issueDescription']
        rowIssue.fecha_registro_solicitudes_asociados  = time
        rowIssue.id_status  = 1
        rowIssue.id_asociado = newPartner(data_parsed)
        rowIssue.save
        if rowIssue.id 
            #sending email..
            arrayIssue =Issue.select("*")
             .joins(:Partner, :Status)
             .where("solicitudes_asociados.id_solicitudes_asociados"=>rowIssue.id)          
             sendIssueNotification(arrayIssue[0])
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

    def issueById
        id = params[:id]
        arrayIssue = Issue.select("*")
        .joins(:Partner, :Status)
        .where("solicitudes_asociados.id_solicitudes_asociados"=>id)
        #render :json => {:data=>arrayComplaint}
        response={'data':arrayIssue[0]}  #sending the first element
        render json: response
    end
    
    def allIssues
        # arrayComplaints =  Complaint.where(id_tipoqueja: 2)
        arrayIssues = Issue.select("*")
        .joins(:Partner, :Status).order(fecha_registro_solicitudes_asociados: :desc)
       # .limit(200);
        render :json => { :data=>arrayIssues } 
    end

    def newPartner(data)
        rowPartner = Partner.new
        rowPartner.nombre_asociado = data['data']['fistNamePartner']
        rowPartner.apellido_asociado = data['data']['lastNamePartner']
        rowPartner.celular_asociado = data['data']['phonePartner']
        rowPartner.email_asociado =  data['data']['emailPartner']
        rowPartner.save
        return rowPartner.id
    end

    def updateIssueById
        
        information = request.raw_post
        data_parsed = JSON.parse(information)
        if data_parsed['data']['solutionIssue'].length && data_parsed['data']['idIssue']
          solutionComplaint = data_parsed['data']['solutionIssue']
          issueId = data_parsed['data']['idIssue']
          issue = Issue.find_by(id_solicitudes_asociados: issueId)
          issue.solucion_solicitudes_asociados = solutionComplaint
          issue.id_status = 2
          issue.fecha_solicion_solicitudes_asociados = Time.now.to_formatted_s(:db) 
          update = issue.save
          if update 
            #sending email
            #get again the issue
            arrayIssue = Issue.select("*").joins(:Partner, :Status)
                    .where(id_solicitudes_asociados: issueId)
            sendIssueResolveNotification(arrayIssue[0])
            msg = { :Status => "OK", 
            :Issue => {:id=> issueId,:folio=>"#{"%08d" % issueId }"}, 
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
  
        else
          #cant write changes.
          msgWrong = { :Status => "ERROR", 
          :Issue => {
              :id=> 0
          }, 
        }
        render :json => { :data=>msgWrong}
        end
    end

    def sendIssueNotification(data)
        # ExampleMailer.sample_email(@user).deliver
        if EmailSenderMailer.issueNewNotification(data).deliver_now 
            return true
        else
            return false
          
        end
    end

    def sendIssueResolveNotification(data)
        # ExampleMailer.sample_email(@user).deliver
        if EmailSenderMailer.issueResolveNotification(data).deliver_now 
            return true
        else
            return false
          
        end
    end
     
  
end

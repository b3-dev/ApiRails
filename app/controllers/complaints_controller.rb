class ComplaintsController < ApplicationController
    #skip_before_action :verify_authenticity_token
    before_action :authenticate_user, only: [:newComplaint, :complaintById]

    def allComplaints
      # arrayComplaints =  Complaint.where(id_tipoqueja: 2)
      arrayComplaints = Complaint.select("*")
      .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
      .order(fechaqueja: :desc)
     # .limit(200);
      render :json => { :data=>arrayComplaints } 
    end

    def complaintById
      id = params[:id]
      arrayComplaint = Complaint.select("*")
      .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
      .where("quejas.id_queja"=>id);
      #render :json => {:data=>arrayComplaint}
      response={'data':arrayComplaint[0]}  #sending the first element
      render json: response
    end
    
    def updateComplaintById
      time = Time.now
      time.to_formatted_s(:db)    
      information = request.raw_post
      data_parsed = JSON.parse(information)
      if data_parsed['data']['solutionComplaint'].length && data_parsed['data']['idComplaint']
        solutionComplaint = data_parsed['data']['solutionComplaint']
        complaintId = data_parsed['data']['idComplaint']
        dateSolutionComplaint = time
        statusId=2
        complaint = Complaint.find_by(id_queja: complaintId)
        complaint.comentario_queja = solutionComplaint
        complaint.id_status = statusId
        complaint.fechasolucion = dateSolutionComplaint
        update = complaint.save
        if update 
          msg = { :Status => "OK", 
          :Complaint => {:id=> complaintId,:folio=>"#{"%08d" % complaintId }"}, 
         } 
         render :json => { :data=>msg }
        else
            msgWrong = { :Status => "ERROR", 
            :Complaint => {
                :id=> 0
            }, 
          }
          render :json => { :data=>msgWrong}
        end

      else
        #cant write changes.
        msgWrong = { :Status => "ERROR", 
        :Complaint => {
            :id=> 0
        }, 
      }
      render :json => { :data=>msgWrong}
      end
    
    end


    def dateToOperativeData(strDate)
      
      #“#{numero1} #{cadena2}”
      #time = DateTime.now.to_date #format yyyy-mm-dd
     
      #puts time.to_formatted_s(:db)  
      #puts time
     
      #strDate='2018-09-26'
      year,month,day = strDate.split('-')
      dyear = Time.mktime(year,month,day,0,0).yday
      #dyear  = time.yday
      #stryear = "%04d" % y 
      #strday ="%03d" % dyear 
      strOperativeDay= "#{"%04d" % year }#{"%03d" % dyear}"
      convertdDay = getPeriodFromStr(strOperativeDay)
      oPeriod = convertdDay[0]
      oWeek = convertdDay[1]
      oDay = convertdDay[2]
      return [year,month,day,strOperativeDay,oPeriod,oWeek,oDay]
       
        #render :json =>{ 
        #  :year=>y, 
        #  :month=>m,
        #  :day=>d,
        #  :operativeDay=>strOperativeDay,
        #  :oPeriod=>convertdDay[0],
        #  :oWeek=>convertdDay[1],
        # :oDay=>convertdDay[2]
        # }
        
    end

    def getPeriodFromStr(strOpDay)
      #2010269 returns 269
      
      operativeDay = strOpDay[4,3]
      day=operativeDay.to_i % 7
      week = (operativeDay.to_i / 7)%4 + 1
      period = ((operativeDay.to_i/7)/4)+1
      if !day 
        day=7
        week-=-1  
      end

      if !week
        week=4
        period -= 1
      end
      return [period,week,day]
    
    end
   
    def newClient(data)
        rowClient = Client.new
        rowClient.nomcliente = data['data']['fistNameClient']
        rowClient.apecliente = data['data']['lastNameClient']
        rowClient.email_cliente = data['data']['emailClient']
        rowClient.telefono =  data['data']['phoneClient']
        rowClient.save
        return rowClient.id
    end

    def newComplaint
      time = Time.now
      time.to_formatted_s(:db)    
      information = request.raw_post
      data_parsed = JSON.parse(information)
      # u = User.new
      #u.external_id = line['user']['id']
      rowComplaint = Complaint.new
      rowComplaint.id_unidad = data_parsed['data']['store']
      rowComplaint.queja = data_parsed['data']['complaintDescription']
      rowComplaint.id_importancia =  data_parsed['data']['importanceLevel']
      #rowComplaint.nomcliente = data_parsed['data']['fistNameClient']
      #get rel supervisor, store
      dataRel = RelStoreSupervisor.all.where(id_unidad:rowComplaint.id_unidad)
      #byebug
      rowComplaint.id_cliente = newClient(data_parsed)
      rowComplaint.id_supervisor = dataRel[0]['id_supervisor']
      rowComplaint.id_zona = dataRel[0]['id_zona']
       #get operative date..
      dataOperative =dateToOperativeData(DateTime.now.to_date.to_formatted_s(:db))
      #that returns  return [year,month,day,operativeDay,oPeriod,oWeek,oDay]
      
      rowComplaint.id_diaoperativo=dataOperative[3]
      rowComplaint.periodo=dataOperative[4]
      rowComplaint.id_tipoqueja= data_parsed['data']['categoryComplaint']
      rowComplaint.id_status = 1
      rowComplaint.id_usuario = current_user.id #generarte by knock..
      rowComplaint.fechaqueja = time
      rowComplaint.save
     # @id = rowComplaint.id  
      if rowComplaint.id 
        msg = { :Status => "OK", 
            :Complaint => {:id=> rowComplaint.id,:folio=>"#{"%08d" % rowComplaint.id }"}, 
        }
       
        render :json => { :data=>msg }
      else
        msgWrong = { :Status => "ERROR", 
                :Complaint => {
                    :id=> 0
                }, 
         }
        render :json => { :data=>msgWrong}
      end
      #@param = params[id]
      #puts rowComplaint.id
      #puts  "datos"+rowComplaint.errors.full_messages.inspect
      # render :json => { :data_parsed[:id]}
      #render text: data_parsed[:id].inspect
    end

    def sendEmail
      
     # ExampleMailer.sample_email(@user).deliver
     if EmailSenderMailer.complaintNewNotification.deliver_now 
      msg='Mensaje enviado'
      render :json => { :data=>msg}
     
     else
     msg='El mensaje no pudo enviarse'
     render :json => { :data=>msg}
       
     end
    end
end

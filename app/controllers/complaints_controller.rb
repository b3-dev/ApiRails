class ComplaintsController < ApplicationController
  #skip_before_action :verify_authenticity_token
  before_action :authenticate_user, only: [:newComplaint, :complaintById, :complaintsPerPage]

  def complaintsPerPage
    #if(params.has_key?(:one) && params.has_key?(:two))
    if (params.has_key?(:page) && params.has_key?(:limit))
      arrayUser = getUserByEmail(request.raw_post)
      pendingComplaints = 0
      dataOperative = dateToOperativeData(DateTime.now.to_date.to_formatted_s(:db))
      #IF USER IS SUPERVISOR THEN GET ONLY THE COMPLAINTS WITH THAT ID
      #IF USER IS ADMIN GET ALL COMPLAINTS
      #IF USER IS MKT THEN GET ALL COMPLAINTS
      #IF USER IS MANAGER ZONE GET ONLY THE COMPLAINTS ABOUT HIS ZONE
      arrayComplaints = []
      if arrayUser["id_autoridad"] == 2 #admin
        #getPeriod
        dataParams = {}
        dataParams["period"] = dataOperative[4]
        #dataParams['page'] = params[:page]
        #dataParams['limit'] = params[:limit]
        arrayComplaints = Complaint.getCurrentComplaintsForAdmin dataParams
      elsif arrayUser["id_autoridad"] == 1 #supervisor
        dataParams = {}
        dataParams["period"] = dataOperative[4]
        dataParams["id_supervisor"] = arrayUser["id_usuario"]
        arrayComplaints = Complaint.getCurrentComplaintsForSupervisor dataParams
        pendingComplaints = Complaint.getCurrentPendingComplaintsForSupervisor dataParams
      elsif arrayUser["id_autoridad"] == 3 #ZONE MANAGER
        dataParams = {}
        dataParams["period"] = dataOperative[4]
        dataParams["id_usuario"] = arrayUser["id_usuario"]
        arrayComplaints = Complaint.getCurrentComplaintsForZoneManager dataParams
        pendingComplaints = Complaint.getCurrentPendingComplaintsForZoneManager dataParams
      elsif arrayUser["id_autoridad"] == 5
        dataParams = {}
        dataParams["period"] = dataOperative[4]
        arrayComplaints = Complaint.getCurrentComplaintsForAdmin dataParams
      else
        arrayComplaints = []
      end

      render :json => { :Status => "OK", :data => arrayComplaints, :period => dataOperative[4], :pending => pendingComplaints }
      #.joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)

    else
      msgWrong = { :Status => "ERROR",
                  :Complaint => {
        :id => 0,
      } }
      render :json => { :data => msgWrong }
    end
  end

  def complaintsPerDates
    #if(params.has_key?(:one) && params.has_key?(:two))
    if (params.has_key?(:page) && params.has_key?(:limit))
      page = params[:page]
      limit = params[:limit]
      #validate dates
      if (params[:dateFrom].present? && params[:dateTo].present?)
        dateFrom = params[:dateFrom] == "empty" ? 30.days.ago.to_date : params[:dateFrom].try(:to_date)
        dateTo = params[:dateTo] == "empty" ? Date.current : params[:dateTo].try(:to_date)
        #rangeDates = (dateFrom....dateTo)
        arrayComplaints = Complaint.select("*")
          .paginate(page: page, per_page: limit)
          .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
          .where("quejas.fechaqueja >= ? AND quejas.fechaqueja <= ?", dateFrom.beginning_of_day, dateTo.end_of_day)
          .order(fechaqueja: :desc)

        counter = allComplaintsByParams(dateFrom.beginning_of_day, dateTo.end_of_day)
        arrayListOptions = getListOptions(counter)
        render :json => { :data => arrayComplaints, :counter => counter, :arrayOptions => arrayListOptions, :dateFrom => dateFrom, :dateTo => dateTo }
      end
    else
      msgWrong = { :Status => "ERROR",
                  :Complaint => {
        :id => 0,
      } }
      render :json => { :data => msgWrong }
    end
  end

  def getListOptions(counter)
    # (67/30.to_f).ceil  # = 3
    array = []
    if (counter <= 10) # a_variable is the variable we want to compare
      array.push(counter)
    elsif (counter > 10 && counter <= 50)
      array.push(((counter / 2).to_f).ceil, counter)
    elsif (counter > 50 && counter <= 100)
      index = ((counter / 3).to_f).ceil
      array.push(index, index * 2, counter)
    else
      array.push(10, 20, 50, counter)
    end

    return array
  end

  def allComplaintsByParams(dateFrom, dateTo)
    arrayComplaints = Complaint.joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
      .where("quejas.fechaqueja >= ? AND quejas.fechaqueja <= ?", dateFrom, dateTo).count

    return arrayComplaints
  end

  def allComplaints
    # arrayComplaints =  Complaint.where(id_tipoqueja: 2)
    arrayComplaints = Complaint.select("*")
      .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
      .order(fechaqueja: :desc)
    # .limit(200);
    render :json => { :data => arrayComplaints }
  end

  def complaintById
    id = params[:id]
    arrayComplaint = Complaint.select("*")
      .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
      .where("quejas.id_queja" => id)
    #render :json => {:data=>arrayComplaint}
    response = { 'data': arrayComplaint[0] }  #sending the first element
    render json: response
  end

  def updateComplaintById
    time = Time.now
    time.to_formatted_s(:db)
    information = request.raw_post
    data_parsed = JSON.parse(information)
    if data_parsed["data"]["solutionComplaint"].length && data_parsed["data"]["idComplaint"]
      solutionComplaint = data_parsed["data"]["solutionComplaint"]
      complaintId = data_parsed["data"]["idComplaint"]
      dateSolutionComplaint = time
      statusId = 2
      complaint = Complaint.find_by(id_queja: complaintId)
      complaint.comentario_queja = solutionComplaint
      complaint.id_status = statusId
      complaint.fechasolucion = dateSolutionComplaint
      update = complaint.save
      if update
        msg = { :Status => "OK",
               :Complaint => { :id => complaintId, :folio => "#{"%08d" % complaintId}" } }
        render :json => { :data => msg }
      else
        msgWrong = { :Status => "ERROR",
                    :Complaint => {
          :id => 0,
        } }
        render :json => { :data => msgWrong }
      end
    else
      #cant write changes.
      msgWrong = { :Status => "ERROR",
                  :Complaint => {
        :id => 0,
      } }
      render :json => { :data => msgWrong }
    end
  end

  def dateToOperativeData(strDate)

    #“#{numero1} #{cadena2}”
    #time = DateTime.now.to_date #format yyyy-mm-dd

    #puts time.to_formatted_s(:db)
    #puts time

    #strDate='2018-09-26'
    year, month, day = strDate.split("-")
    dyear = Time.mktime(year, month, day, 0, 0).yday
    #dyear  = time.yday
    #stryear = "%04d" % y
    #strday ="%03d" % dyear
    strOperativeDay = "#{"%04d" % year}#{"%03d" % dyear}"
    convertdDay = getPeriodFromStr(strOperativeDay)
    oPeriod = convertdDay[0]
    oWeek = convertdDay[1]
    oDay = convertdDay[2]
    return [year, month, day, strOperativeDay, oPeriod, oWeek, oDay]
  end

  def getPeriodFromStr(strOpDay)
    #2010269 returns 269

    operativeDay = strOpDay[4, 3]
    day = operativeDay.to_i % 7
    week = (operativeDay.to_i / 7) % 4 + 1
    period = ((operativeDay.to_i / 7) / 4) + 1
    if !day
      day = 7
      week -= -1
    end

    if !week
      week = 4
      period -= 1
    end
    return [period, week, day]
  end

  def newClient(data)
    rowClient = Client.new
    rowClient.nomcliente = data["data"]["fistNameClient"]
    rowClient.apecliente = data["data"]["lastNameClient"]
    rowClient.email_cliente = data["data"]["emailClient"]
    rowClient.telefono = data["data"]["phoneClient"]
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
    rowComplaint.id_unidad = data_parsed["data"]["store"]
    rowComplaint.queja = data_parsed["data"]["complaintDescription"]
    rowComplaint.id_importancia = data_parsed["data"]["importanceLevel"]
    #rowComplaint.nomcliente = data_parsed['data']['fistNameClient']
    #get rel supervisor, store
    dataRel = RelStoreSupervisor.all.where(id_unidad: rowComplaint.id_unidad)
    #byebug
    rowComplaint.id_cliente = newClient(data_parsed)
    rowComplaint.id_supervisor = dataRel[0]["id_supervisor"]
    rowComplaint.id_zona = dataRel[0]["id_zona"]
    #get operative date..
    dataOperative = dateToOperativeData(DateTime.now.to_date.to_formatted_s(:db))
    #that returns  return [year,month,day,operativeDay,oPeriod,oWeek,oDay]
    rowComplaint.id_diaoperativo = dataOperative[3]
    rowComplaint.periodo = dataOperative[4]
    rowComplaint.id_tipoqueja = data_parsed["data"]["categoryComplaint"]
    rowComplaint.id_status = 1
    rowComplaint.id_usuario = current_user.id #generarte by knock..
    rowComplaint.fechaqueja = time
    rowComplaint.save
    # @id = rowComplaint.id
    if rowComplaint.id
      arrayFullComplaint = parsingComplaintDataForEmail(rowComplaint.id)
      # puts 'array parseado' +arrayFullComplaint[0]
      sendComplaintNotification(arrayFullComplaint[0])
      #puts 'parsing'+array.to_s
      msg = { :Status => "OK",
             :Complaint => { :id => rowComplaint.id, :folio => "#{"%08d" % rowComplaint.id}" }, :full => arrayFullComplaint }

      render :json => { :data => msg }
    else
      msgWrong = { :Status => "ERROR",
                  :Complaint => {
        :id => 0,
      } }
      render :json => { :data => msgWrong }
    end
    #@param = params[id]
    #puts rowComplaint.id
    #puts  "datos"+rowComplaint.errors.full_messages.inspect
    # render :json => { :data_parsed[:id]}
    #render text: data_parsed[:id].inspect
  end

  def sendComplaintNotification(data)
    if EmailSenderMailer.complaintNewNotification(data).deliver_now
      return true
    else
      return false
    end
  end

  def parsingComplaintDataForEmail(complaintId)
    arrayComplaintFull = []
    arrayComplaint = Complaint.select("*")
      .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status, :Zone, :ImportanceLevel)
      .where("quejas.id_queja" => complaintId)

    #empty?
    if !arrayComplaint[0].blank?
      rowComplaint = arrayComplaint[0]
      rowSupervisors = getSupervisorsByStore(arrayComplaint[0]["id_unidad"])
      arrayComplaintFull.push(

        {
          complaint: rowComplaint,
          storeName: getStoreName(arrayComplaint[0]["id_unidad"]),
          supervisors: rowSupervisors,
        }
      )
    end

    return arrayComplaintFull
  end

  def getSupervisorsByStore(storeId)
    if !storeId.blank?
      arraySupervisor = RelStoreSupervisor.select("*")
        .joins(:Supervisor, :Manager)
        .where(id_unidad: storeId)

      return arraySupervisor[0]
    else
      return null
    end
  end

  def getStoreName(storeId)
    if !storeId.blank?
      storeName = Store.all.where(id_unidad: storeId)
      return storeName[0]["nombre_unidad"].to_s
    else
      return null
    end
  end

  def sendEmail
    # ExampleMailer.sample_email(@user).deliver
    if EmailSenderMailer.complaintNewNotification.deliver_now
      msg = "Mensaje enviado"
      render :json => { :data => msg }
    else
      msg = "El mensaje no pudo enviarse"
      render :json => { :data => msg }
    end
  end

  def getUserByEmail(data)
    # data =  request.raw_post
    data_parsed = JSON.parse(data)
    #KNOCK GETS THE USER BY TOKEN PASSED, USING THE EMAIL EMBEBED ON AUTH ARRAY.
    #THIS IS LIKE THE LOGIN METHOD
    user = User.from_token_request data_parsed
    return user
  end
end

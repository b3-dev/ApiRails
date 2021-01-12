class Complaint < ActiveRecord::Base
  establish_connection(:development)
  self.table_name = "quejas"
  self.primary_key = "id_queja"

  belongs_to :Client, :foreign_key => "id_cliente"
  belongs_to :Supervisor, :foreign_key => "id_supervisor"
  belongs_to :User, :foreign_key => "id_usuario"
  belongs_to :CategoryComplaint, :foreign_key => "id_tipoqueja"
  belongs_to :Status, :foreign_key => "id_status"
  belongs_to :Zone, :foreign_key => "id_zona"
  belongs_to :ImportanceLevel, :foreign_key => "id_importancia"
  has_many :Manager, :through => :Supervisor

  #  belongs_to :Store, :foreign_key=>'id_unidad'

  def self.getCurrentComplaintsForAdmin(dataParams)
    period = dataParams["period"]
    arrayComplaints = Complaint.select("*")
      .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
      .where(periodo: period) #current year..
      .where("extract(year from fechaqueja) = ?", Time.current.year)
      .order(fechaqueja: :desc)
    return arrayComplaints
  end

  def self.getCurrentComplaintsForSupervisor(dataParams)
    period = dataParams["period"]
    supervisorId = dataParams["id_supervisor"]
    arrayComplaints = Complaint.select("*")
      .joins(:Client, :Supervisor, :User, :CategoryComplaint, :Status)
      .where("extract(year from fechaqueja) = ?", Time.current.year)
      .where(periodo: period) #current year..
      .where(id_supervisor: supervisorId)
      .order(fechaqueja: :desc)
    return arrayComplaints
  end

  def self.getCurrentPendingComplaintsForSupervisor(dataParams)
    period = dataParams["period"]
    supervisorId = dataParams["id_supervisor"]
    arrayComplaints = Complaint.select("COUNT(id_queja) AS pending")
      .where("extract(year from fechaqueja) = ?", Time.current.year)
      .where(periodo: period) #current year..
      .where(id_supervisor: supervisorId)
      .where(id_status: 1)

    return arrayComplaints.first.pending
  end

  def self.getCurrentComplaintsForZoneManager(dataParams)
    period = dataParams["period"]
    supervisorId = dataParams["id_supervisor"]
    userId = dataParams["id_usuario"]
    arrayComplaints = Complaint.select("*")
      .joins(:Client, :Supervisor, :Manager, :User, :CategoryComplaint, :Status)
      .where("extract(year from fechaqueja) = ?", Time.current.year)
      .where(periodo: period) #current year..
      .where("(gerentes.id_usuario=? or quejas.id_unidad=0)", userId)
      .order(fechaqueja: :desc)
    return arrayComplaints
  end

  def self.getCurrentPendingComplaintsForZoneManager(dataParams)
    period = dataParams["period"]
    supervisorId = dataParams["id_supervisor"]
    userId = dataParams["id_usuario"]
    arrayComplaints = Complaint.select("COUNT(id_queja) AS pending")
      .joins(:Client, :Supervisor, :Manager, :User, :CategoryComplaint, :Status)
      .where("extract(year from fechaqueja) = ?", Time.current.year)
      .where(periodo: period) #current year..
      .where("(gerentes.id_usuario=? or quejas.id_unidad=0)", userId)
      .where(id_status: 1)
      .order(fechaqueja: :desc)
    return arrayComplaints.first.pending
  end
end

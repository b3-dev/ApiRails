class Complaint < ActiveRecord::Base
    establish_connection(:development)
    #ActiveRecord::Base.establish_connection(:development)

    self.table_name =  'quejas'
    self.primary_key =  'id_queja'

    belongs_to :Client, :foreign_key => 'id_cliente'
    belongs_to :Supervisor, :foreign_key=>'id_supervisor'
    belongs_to :User, :foreign_key=>'id_usuario'
    belongs_to :CategoryComplaint, :foreign_key=>'id_tipoqueja'
    belongs_to :Status, :foreign_key=>'id_status'
  #  belongs_to :Store, :foreign_key=>'id_unidad'

end

 
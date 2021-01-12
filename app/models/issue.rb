class Issue < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)

    self.table_name =  'solicitudes_asociados'
    self.primary_key =  'id_solicitudes_asociados'

    belongs_to :Partner, :foreign_key => 'id_asociado'
    belongs_to :Status, :foreign_key=>'id_status'


end

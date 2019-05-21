class RelStoreSupervisor < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'rel_unidad_supervisor'
    self.primary_key =  'id_rel_unidad_supervisor'

    belongs_to :Supervisor, :foreign_key => 'id_supervisor'
    
    has_many :Manager,  :through => :Supervisor

end

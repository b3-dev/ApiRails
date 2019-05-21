class Supervisor < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)

    self.table_name =  'supervisores'
    self.primary_key =  'id_supervisor'

    has_many :RelStoreSupervisor 
    belongs_to :Manager, :foreign_key => 'id_gerente'

end

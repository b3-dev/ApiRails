class Manager < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'gerentes'
    self.primary_key =  'id_gerente'

    has_many :Supervisor
     

    #belongs_to :Supervisor, :foreign_key => 'id_gerente'
end

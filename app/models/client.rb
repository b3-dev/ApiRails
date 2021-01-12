class Client < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'clientes'
    self.primary_key =  'id_cliente'
   
    has_many :Complaint 
end

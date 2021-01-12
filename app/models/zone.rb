class Zone < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)

    self.table_name =  'zonas'
    self.primary_key =  'id_zona'
    has_many :Complaint 
end

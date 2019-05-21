class Status < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'status'
    self.primary_key =  'id_status'

    has_many :Complaint 
end

class Partner < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'asociados'
    self.primary_key =  'id_asociado'

    has_many :Issue 
end

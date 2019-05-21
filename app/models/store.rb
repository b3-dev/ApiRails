class Store < ActiveRecord::Base
    #ActiveRecord::Base.establish_connection(:development_sec)
    establish_connection(:development_sec)
   # self.abstract_class = true
    self.table_name =  'unidad'
    self.primary_key =  'id_unidad'
    #has_many :Complaint   

end


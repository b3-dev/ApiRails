class ImportanceLevel < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'importancia'
    self.primary_key =  'id_importancia'

    has_many :Complaint 


    #change ApplicationRecord by < ActiveRecord::Base

end

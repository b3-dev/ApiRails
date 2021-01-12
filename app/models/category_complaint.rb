class CategoryComplaint < ActiveRecord::Base
  ActiveRecord::Base.establish_connection(:development)

  self.table_name = "tipoqueja"
  self.primary_key = "id_tipoqueja"

  has_many :Complaint
end

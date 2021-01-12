class AuthLevel < ActiveRecord::Base
  ActiveRecord::Base.establish_connection(:development)

  self.table_name = "autoridad"
  self.primary_key = "id_autoridad"

  has_many :User
  has_many :AppRelParentChildMenu
end

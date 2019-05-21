class User < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
     has_secure_password

    self.table_name =  'usuarios'
    self.primary_key =  'id_usuario'

    has_many :Complaint 
    validates_uniqueness_of :email
    validates :password, presence: true

    def self.from_token_request request
        
        email = request["auth"] && request["auth"]["email"]
        user =  self.find_by email: email
        return user
   end
end

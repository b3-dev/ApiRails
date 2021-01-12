class User < ActiveRecord::Base
  ActiveRecord::Base.establish_connection(:development)
  has_secure_password

  self.table_name = "usuarios"
  self.primary_key = "id_usuario"

  has_many :Complaint
  belongs_to :AuthLevel, :foreign_key => "id_autoridad"

  validates_uniqueness_of :email
  validates :password, presence: true

  def self.from_token_request(request)
    email = request["auth"] && request["auth"]["email"]
    user = self.find_by email: email
    return user
  end

  def self.create_account(request)
    @current_password = "111"
    @hashed_password = BCrypt::Password.create(@current_password)
    puts @hashed_password
    self.create!(nomusuario: "john",
                 apusuario: "d03",
                 login: "john@doe3.com",
                 email: "john@doe2.com",
                 password_remember: "111",
                 vigencia: 1,
                 id_autoridad: 1)

    # return user
  end
end

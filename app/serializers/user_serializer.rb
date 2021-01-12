class UserSerializer < ActiveModel::Serializer
  attributes :id_usuario,
             :nomusuario,
             :apusuario,
             :email,
             :password
end

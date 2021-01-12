class AuthLevelController < ApplicationController
  def allAuthLevels
    arrayAuthLevels = AuthLevel.all
      .order(id_autoridad: :asc)

    render :json => { :Status => "OK", :data => arrayAuthLevels }
  end
end

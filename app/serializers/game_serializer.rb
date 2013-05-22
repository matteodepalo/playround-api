class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :display_name, :image_url

  def image_url
    ActionController::Base.helpers.asset_path(object.image_file)
  end
end
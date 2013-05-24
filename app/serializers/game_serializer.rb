class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :display_name, :image_url

  def image_url
    asset_url(object.image_file)
  end
end
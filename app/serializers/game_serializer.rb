class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :display_name, :picture_url, :teams
  self.root = 'game'

  def picture_url
    asset_url(object.image_file)
  end
end
class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :display_name, :image_url, :number_of_teams
  self.root = 'game'

  def image_url
    asset_url(object.image_file)
  end
end
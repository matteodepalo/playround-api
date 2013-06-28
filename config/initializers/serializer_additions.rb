module SerializerAdditions
  def asset_url(asset)
    "#{ActionController::Base.asset_host}#{ActionController::Base.helpers.asset_path(asset)}"
  end
end

ActiveModel::Serializer.send(:include, SerializerAdditions)
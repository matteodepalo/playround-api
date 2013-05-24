module SerializerAdditions
  def asset_url(asset)
    url = "#{url_options[:protocol]}#{url_options[:host]}"
    url << ":#{url_options[:port]}" if url_options[:port]
    url << ActionController::Base.helpers.asset_path(asset)
  end
end

ActiveModel::Serializer.send(:include, SerializerAdditions)
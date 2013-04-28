require 'spec_helper'

describe 'Api Configuration' do
  it 'redirects to the latest version when a nonexistent version is specified' do
    get '/v10/rounds'

    response.should redirect_to('/v1/rounds')
  end

  it 'redirects to the latest version if no version is specified' do
    get '/rounds'

    response.should redirect_to('/v1/rounds')
  end
end
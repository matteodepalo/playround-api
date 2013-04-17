require 'spec_helper'

describe 'Api Configuration' do
  it 'redirects to the latest version when a nonexistent version is specified' do
    get '/api/v10/rounds'
    response.should redirect_to('/api/v1/rounds')
  end

  it 'redirects to the latest version if no version is specified' do
    get '/api/rounds'

    response.should redirect_to('/api/v1/rounds')
  end
end
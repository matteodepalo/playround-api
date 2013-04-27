require 'spec_helper'

describe 'Rounds Requests' do
  valid_attributes = {}

  describe 'GET /rounds/1' do
    it 'returns the requested round' do
      round = create :round
      get api_v1_round_path(round)
      response.status.should eq(200)
    end
  end

  describe 'GET /rounds' do
    it 'returns the list of rounds' do
      round = create :round
      get api_v1_rounds_path
      response.status.should eq(200)
    end
  end

  describe 'POST /rounds' do
    it 'succeeds with valid params' do
      post api_v1_rounds_path, :round => valid_attributes
      response.status.should eq(201)
    end

    it 'fails and returns error unprocessable entity with invalid params' do
      post api_v1_rounds_path, :round => {}
      response.status.should eq(422)
      response.body.should include('errors')
    end
  end

  describe 'PATCH /rounds/1' do
    it 'succeeds with valid params' do
      round = create :round
      patch api_v1_round_path(:id => round.to_param), :round => valid_attributes
      response.status.should eq(200)
    end

    it 'fails and returns error unprocessable entity with invalid params' do
      round = create :round
      patch api_v1_round_path(:id => round.to_param), :round => {}
      response.status.should eq(422)
      response.body.should include('errors')
    end
  end

  describe 'DELETE /rounds/1' do
    it 'succeeds with valid params' do
      round = create :round
      delete api_v1_round_path(round)
      response.status.should eq(204)
    end
  end
end
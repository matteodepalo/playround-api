class AddExtensions < ActiveRecord::Migration
  def change
    execute "create extension \"uuid-ossp\""
    execute "create extension postgis" if Rails.env.production?
  end
end

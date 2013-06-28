class AddExtensions < ActiveRecord::Migration
  def change
    execute "create extension \"uuid-ossp\""
  end
end

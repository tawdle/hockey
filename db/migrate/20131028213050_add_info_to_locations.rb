class AddInfoToLocations < ActiveRecord::Migration
  def change
    [:address_1, :address_2, :city, :state, :zip, :country, :telephone, :email, :website].each do |key|
      add_column :locations, key, :string
    end
  end
end

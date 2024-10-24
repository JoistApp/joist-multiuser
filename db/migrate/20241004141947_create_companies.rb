class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :street
      t.string :suite
      t.string :city
      t.string :zip
      t.string :state
      t.string :country
      t.string :email
      t.string :phone
      t.string :website
      t.string :business_number

      t.timestamps
    end
  end
end

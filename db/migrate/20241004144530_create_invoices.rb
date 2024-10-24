class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.column :user_id, :integer, null: false

      t.timestamps
    end
  end
end

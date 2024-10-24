class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.boolean :is_primary, default: false
      t.boolean :roles_visible, default: false
      t.boolean :roles_enabled, default: false
      t.boolean :estimates_visible, default: false
      t.boolean :estimates_enabled, default: false
      t.boolean :invoice_visible, default: false
      t.boolean :invoice_enabled, default: false
      t.boolean :settings_visible, default: false
      t.boolean :settings_enabled, default: false
      t.column :company_id, :integer, null: true

      t.timestamps
    end
  end
end

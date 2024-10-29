# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Seed the roles table
Role.seed(:id, :name) do |s|
  s.id = 1
  s.name = "Company Owner"
  s.description = "Company Owner"
  s.is_primary = true
  s.roles_visible = true
  s.roles_enabled = true
  s.users_visible = true
  s.users_enabled = true
  s.estimates_enabled = true
  s.invoices_enabled = true
  s.settings_visible = true
  s.settings_enabled = true
end
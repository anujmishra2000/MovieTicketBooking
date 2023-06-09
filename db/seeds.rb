# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

  Country.delete_all
  Country.create!(id: 1, name: 'India', iso_code: 'IN91')
  Country.create!(id: 2, name: 'Russia', iso_code: 'RS92')

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Homework.Repo.insert!(%Homework.Users.User{dob: "08/04/1989", last_name: "Smith", first_name: "John"})
Homework.Repo.insert!(%Homework.Users.User{dob: "08/07/1989", last_name: "Brent", first_name: "Taylor"})
Homework.Repo.insert!(%Homework.Users.User{dob: "08/07/1980", last_name: "Jake", first_name: "Moncur"})
Homework.Repo.insert!(%Homework.Users.User{dob: "08/07/1990", last_name: "Brent", first_name: "Everman"})


Homework.Repo.insert!(%Homework.Merchants.Merchant{name: "chocolate house", description: "Merchant description 1"})
Homework.Repo.insert!(%Homework.Merchants.Merchant{name: "traders", description: "Merchant description 2"})
Homework.Repo.insert!(%Homework.Merchants.Merchant{name: "chocolate fantasy", description: "Merchant description 3"})

## credit_line & available_credit are in cents
Homework.Repo.insert!(%Homework.Companies.Company{name: "Lehi chocolate factory", credit_line: 50000, available_credit: 50000})
Homework.Repo.insert!(%Homework.Companies.Company{name: "Lehi Traders", credit_line: 30000, available_credit: 30000})

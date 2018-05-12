# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Multiauth.Repo.insert!(%Multiauth.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Multiauth.Auth.create_user(%{username: "drapadubok", password: "admin", email: "dmitry@yousician.com"})

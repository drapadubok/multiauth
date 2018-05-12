defmodule Multiauth.AuthTest do
  use Multiauth.DataCase

  alias Comeonin.Bcrypt
  alias Multiauth.Auth
  alias Multiauth.Auth.Guardian
  alias Multiauth.Auth.User

  describe "users" do
    @valid_attrs %{email: "some email", is_admin: false, password: "some password", username: "some username"}
    @update_attrs %{email: "some updated email", is_admin: false, password: "some updated password", username: "some updated username"}
    @invalid_attrs %{email: nil, is_admin: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.is_admin == false
      assert Bcrypt.checkpw("some password", user.password) == true
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Auth.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.is_admin == false
      assert Bcrypt.checkpw("some updated password", user.password) == true
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end

    test "#subject_for_token for %User{} returns <id>" do
      user = user_fixture()
      assert Guardian.subject_for_token(user, nil) == {:ok, "#{user.id}"}
    end

    test "#subject_for_token for unknown resource returns :unknown_resource" do
      assert Guardian.subject_for_token(%{some: "thing"}, nil) == {:error, :unknown_resource}
    end

    test "#resource_from_claims for <valid_id> returns {:ok, %User{}}" do
      user = user_fixture()
      assert Guardian.resource_from_claims(%{"sub" => user.id}) == {:ok, user}
    end
  end
end

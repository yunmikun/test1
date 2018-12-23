defmodule Test1.AccountsTest do
  use Test1.DataCase

  alias Test1.Accounts

  describe "users" do
    alias Test1.Accounts.User

    @valid_attrs %{bio: "some bio", email: "some@email", name: "some name", password: "some password"}
    @update_attrs %{bio: "some updated bio", email: "some_updated@email", name: "some updated name", password: "some updated password"}
    @invalid_attrs %{bio: nil, email: nil, name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} = attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()
      user
      |> Repo.preload(:events)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.bio == "some bio"
      assert user.email == "some@email"
      assert user.name == "some name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/3 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, user, @update_attrs)
      assert user.bio == "some updated bio"
      assert user.email == "some_updated@email"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
    end

    test "update_user/3 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "update_user/3 with wrong user doesn't work" do
      user1 = user_fixture()
      user2 = user_fixture(email: "another@email.com")
      assert {:error, :wrong_user} = Accounts.update_user(user1, user2, @update_attrs)
    end

    test "delete_user/2 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user, user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "delete_user/2 doesn't delete the user if attempted by another user" do
      user1 = user_fixture()
      user2 = user_fixture(email: "another@email.com")
      assert {:error, :wrong_user} = Accounts.delete_user(user1, user2)
    end

    test "change_user/2 returns a user changeset with `:ok` atom" do
      user = user_fixture()
      assert {:ok, %Ecto.Changeset{}} = Accounts.change_user(user, user)
    end

    test "change_user/2 returns an `{:error, :wrong_user}` when attempted by another user" do
      user1 = user_fixture()
      user2 = user_fixture(email: "another@email.com")
      assert {:error, :wrong_user} = Accounts.delete_user(user1, user2)
    end
  end
end

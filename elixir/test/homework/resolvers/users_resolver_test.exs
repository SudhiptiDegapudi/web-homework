defmodule Homework.Resolvers.UsersResolverTest do
  use Homework.DataCase

  alias Homework.Users
  alias HomeworkWeb.Resolvers.UsersResolver

  describe "users" do


    test "users/3 returns all users" do
     # No user is created
     {:ok, users} = UsersResolver.users(nil, nil, nil)
     assert length(users) == 0

     # New user with below attributes is created
       Users.create_user(%{
        first_name: "John",
        last_name: "smith",
        dob: "08/04/1989"
      })
      {:ok, users} = UsersResolver.users(nil, nil, nil)
      assert length(users) == 1
    end

    test "create_user/3 returns created user" do
     # No user is created
     {:ok, users} = UsersResolver.users(nil, nil, nil)
     assert length(users) == 0

     # New user with below attributes is created
      args = %{
         first_name: "John",
         last_name: "smith",
         dob: "08/04/1989"
       }
      {:ok, user} = UsersResolver.create_user(nil, args, nil)
      assert user.first_name == "John"
      assert user.last_name == "smith"
    end

    test "create_user/3 returns error with invalid attributes" do
      # New user with invalid attributes is created
       args = %{
       first_name: nil,
       last_name: "smith",
       dob: "08/04/1989"
       }

       {:error, error} = UsersResolver.create_user(nil, args, nil)
       assert error =~ "could not create user"
    end

    test "update_user/3 with different attributes" do
      {:ok, user}  = Users.create_user(%{
        first_name: "John",
        last_name: "smith",
        dob: "08/04/1989"
       })
      # New user with valid id attribute is created
       args = %{
         id: user.id,
         first_name: "John123"
       }

       {:ok, user} = UsersResolver.update_user(nil, args, nil)
       assert user.first_name == "John123"

       # New user with invalid id is created -- expects Ecto.NoResultsError
        args = %{
          id: "2f005f74-52dd-4c27-b8b1-619504d11d93",
          first_name: "John123"
        }

        assert_raise Ecto.NoResultsError, fn ->
          UsersResolver.update_user(nil, args, nil)
        end

        # New user with nil id is created -- expects ArgumentError
         args = %{
           id: nil,
           first_name: "John123"
         }

         assert_raise ArgumentError, fn ->
           UsersResolver.update_user(nil, args, nil)
         end
    end


    test "delete_user/3 with different attributes" do
      {:ok, user}  = Users.create_user(%{
          first_name: "John",
          last_name: "smith",
          dob: "08/04/1989"
       })
      # New user with valid id attribute is created
       args = %{
         id: user.id
       }

       {:ok, del_user} = UsersResolver.delete_user(nil, args, nil)
       assert del_user.id == user.id

       # New user with invalid id is created -- expects Ecto.NoResultsError
        args = %{
          id: "2f005f74-52dd-4c27-b8b1-619504d11d93"
        }

        assert_raise Ecto.NoResultsError, fn ->
          UsersResolver.update_user(nil, args, nil)
        end

        # New user with nil id is created -- expects ArgumentError
         args = %{
           id: nil
         }

         assert_raise ArgumentError, fn ->
           UsersResolver.delete_user(nil, args, nil)
         end
    end

    test "search_by_name/3 returns error with different attributes" do
      {:ok, user1}  = Users.create_user(%{
          first_name: "John",
          last_name: "smith",
          dob: "08/04/1989"
       })

       {:ok, user2}  = Users.create_user(%{
           first_name: "Joseph",
           last_name: "Taylor",
           dob: "08/04/1989"
        })

        {:ok, _user3}  = Users.create_user(%{
            first_name: "Amy",
            last_name: "Taylor",
            dob: "08/04/1989"
         })

      # New user is created
      {:ok, users} = UsersResolver.search_user_by_name(nil, %{name: "Jo"}, nil)
      assert length(users) == 2
      assert users == [user1, user2]
    end
  end
end

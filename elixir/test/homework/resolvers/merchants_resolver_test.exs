defmodule Homework.Resolvers.MerchantsResolverTest do
  use Homework.DataCase

  alias Homework.Merchants
  alias HomeworkWeb.Resolvers.MerchantsResolver

  describe "merchants" do


    test "merchants/3 returns all merchants" do
     # No merchant is created
     {:ok, merchants} = MerchantsResolver.merchants(nil, nil, nil)
     assert length(merchants) == 0

     # New merchant with below attributes is created
       Merchants.create_merchant(%{
        name: "some name",
        description: "some description"
      })
      {:ok, merchants} = MerchantsResolver.merchants(nil, nil, nil)
      assert length(merchants) == 1
    end

    test "create_merchant/3 returns created merchant" do
     # No merchant is created
     {:ok, merchants} = MerchantsResolver.merchants(nil, nil, nil)
     assert length(merchants) == 0

     # New merchant with below attributes is created
      args = %{
        name: "some name",
        description: "some description"
      }
      {:ok, merchant} = MerchantsResolver.create_merchant(nil, args, nil)
      assert merchant.name == "some name"
      assert merchant.description == "some description"
    end

    test "create_merchant/3 returns error with invalid attributes" do
      # New Merchant with invalid attributes is created
       args = %{
         name: nil,
         description: "desc"
       }

       {:error, error} = MerchantsResolver.create_merchant(nil, args, nil)
       assert error =~ "could not create merchant"
    end

    test "update_merchant/3 returns error with different attributes" do
      {:ok, merchant}  = Merchants.create_merchant(%{
         name: "some name",
         description: "some description"
       })
      # New Merchant with valid id attribute is created
       args = %{
         id: merchant.id,
         description: "new description"
       }

       {:ok, merchant} = MerchantsResolver.update_merchant(nil, args, nil)
       assert merchant.description == "new description"

       # New Merchant with invalid id is created -- expects Ecto.NoResultsError
        args = %{
          id: "2f005f74-52dd-4c27-b8b1-619504d11d93",
          description: "new description"
        }

        assert_raise Ecto.NoResultsError, fn ->
          MerchantsResolver.update_merchant(nil, args, nil)
        end

        # New Merchant with nil id is created -- expects ArgumentError
         args = %{
           id: nil,
           description: "new description"
         }

         assert_raise ArgumentError, fn ->
           MerchantsResolver.update_merchant(nil, args, nil)
         end
    end


    test "delete_merchant/3 with different attributes" do
      {:ok, merchant}  = Merchants.create_merchant(%{
       name: "some name",
       description: "some description"
       })
      # New Merchant with valid id attribute is created
       args = %{
         id: merchant.id
       }

       {:ok, del_merchant} = MerchantsResolver.delete_merchant(nil, args, nil)
       assert del_merchant.id == merchant.id

       # New Merchant with invalid id is created -- expects Ecto.NoResultsError
        args = %{
          id: "2f005f74-52dd-4c27-b8b1-619504d11d93"
        }

        assert_raise Ecto.NoResultsError, fn ->
          MerchantsResolver.update_merchant(nil, args, nil)
        end

        # New Merchant with nil id is created -- expects ArgumentError
         args = %{
           id: nil
         }

         assert_raise ArgumentError, fn ->
           MerchantsResolver.delete_merchant(nil, args, nil)
         end
    end

    test "search_by_name/3 returns error with different attributes" do
      {:ok, merchant}  = Merchants.create_merchant(%{description: "some description", name: "Chocolate Factory"})
      # New Merchant is created
      {:ok, merchants} = MerchantsResolver.search_by_name(nil, %{name: "Chocolate Factory"}, nil)
      assert length(merchants) == 1
      assert merchants == [merchant]
    end
  end
end

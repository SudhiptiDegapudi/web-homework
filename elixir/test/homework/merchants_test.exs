defmodule Homework.MerchantsTest do
  use Homework.DataCase

  alias Homework.Merchants

  describe "merchants" do
    alias Homework.Merchants.Merchant

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{
      description: "some updated description",
      name: "some updated name"
    }

    @search_attrs1 %{description: "some description", name: "Chocolate Factory"}
    @search_attrs2 %{description: "some description", name: "Lehi Traders"}
    @search_attrs3 %{description: "some description", name: "Lehi Bakers"}

    @update_attrs %{
      description: "some updated description",
      name: "some updated name"
    }

    @invalid_attrs %{description: nil, name: nil}

    def merchant_fixture(attrs \\ %{}) do
      {:ok, merchant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Merchants.create_merchant()

      merchant
    end

    def merchant_search_fixture1(attrs \\ %{}) do
      {:ok, merchant} =
        attrs
        |> Enum.into(@search_attrs1)
        |> Merchants.create_merchant()

      merchant
    end

    def merchant_search_fixture2(attrs \\ %{}) do
      {:ok, merchant} =
        attrs
        |> Enum.into(@search_attrs2)
        |> Merchants.create_merchant()

      merchant
    end

    def merchant_search_fixture3(attrs \\ %{}) do
      {:ok, merchant} =
        attrs
        |> Enum.into(@search_attrs3)
        |> Merchants.create_merchant()

      merchant
    end

    test "list_merchants/1 returns all merchants" do
      merchant = merchant_fixture()
      assert Merchants.list_merchants([]) == [merchant]
    end

    test "get_merchant!/1 returns the merchant with given id" do
      merchant = merchant_fixture()
      assert Merchants.get_merchant!(merchant.id) == merchant
    end

    test "create_merchant/1 with valid data creates a merchant" do
      assert {:ok, %Merchant{} = merchant} = Merchants.create_merchant(@valid_attrs)
      assert merchant.description == "some description"
      assert merchant.name == "some name"
    end

    test "create_merchant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Merchants.create_merchant(@invalid_attrs)
    end

    test "update_merchant/2 with valid data updates the merchant" do
      merchant = merchant_fixture()
      assert {:ok, %Merchant{} = merchant} = Merchants.update_merchant(merchant, @update_attrs)
      assert merchant.description == "some updated description"
      assert merchant.name == "some updated name"
    end

    test "update_merchant/2 with invalid data returns error changeset" do
      merchant = merchant_fixture()
      assert {:error, %Ecto.Changeset{}} = Merchants.update_merchant(merchant, @invalid_attrs)
      assert merchant == Merchants.get_merchant!(merchant.id)
    end

    test "delete_merchant/1 deletes the merchant" do
      merchant = merchant_fixture()
      assert {:ok, %Merchant{}} = Merchants.delete_merchant(merchant)
      assert_raise Ecto.NoResultsError, fn -> Merchants.get_merchant!(merchant.id) end
    end

    test "change_merchant/1 returns a merchant changeset" do
      merchant = merchant_fixture()
      assert %Ecto.Changeset{} = Merchants.change_merchant(merchant)
    end

    test "search_merchant_by_name/1 returns all merchants matching a string" do
      # created merchant with search fixture 1 and 2
      merchant1 = merchant_search_fixture1()
      assert Merchants.list_merchants([]) == [merchant1]
      name = "Cho"
      assert Merchants.search_merchant_by_name!(name) == [merchant1]
      merchant_search_fixture2()
      merchant_search_fixture3()
      name = "Lehi"
      assert length(Merchants.search_merchant_by_name!(name)) == 2
    end
  end
end

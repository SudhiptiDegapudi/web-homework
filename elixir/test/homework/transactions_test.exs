defmodule Homework.TransactionsTest do
  use Homework.DataCase

  alias Homework.Merchants
  alias Homework.Transactions
  alias Homework.Users
  alias Homework.Companies

  describe "transactions" do
    alias Homework.Transactions.Transaction

    setup do
      {:ok, merchant1} =
        Merchants.create_merchant(%{description: "some description", name: "some name"})

      {:ok, merchant2} =
        Merchants.create_merchant(%{
          description: "some updated description",
          name: "some updated name"
        })

      {:ok, user1} =
        Users.create_user(%{
          dob: "some dob",
          first_name: "some first_name",
          last_name: "some last_name"
        })

      {:ok, user2} =
        Users.create_user(%{
          dob: "some updated dob",
          first_name: "some updated first_name",
          last_name: "some updated last_name"
        })

      {:ok, company1} =
        Companies.create_company(%{
          name: "some name",
          available_credit: 5000,
          credit_line: 5000
        })

      {:ok, company2} =
        Companies.create_company(%{
          name: "some updated name",
          available_credit: 3000,
          credit_line: 5000
        })


      valid_attrs = %{
        amount: 42,
        credit: true,
        debit: true,
        description: "some description",
        merchant_id: merchant1.id,
        user_id: user1.id,
        company_id: company1.id
      }

      valid_attrs1 = %{
        amount: 32,
        credit: true,
        debit: true,
        description: "some description",
        merchant_id: merchant1.id,
        user_id: user1.id,
        company_id: company1.id
      }

      valid_attrs2 = %{
        amount: 33,
        credit: true,
        debit: true,
        description: "some description",
        merchant_id: merchant1.id,
        user_id: user1.id,
        company_id: company1.id
      }

      update_attrs = %{
        amount: 43,
        credit: false,
        debit: false,
        description: "some updated description",
        merchant_id: merchant2.id,
        company_id: company2.id,
        user_id: user2.id
      }

      invalid_attrs = %{
        amount: nil,
        credit: nil,
        debit: nil,
        description: nil,
        merchant_id: nil,
        user_id: nil,
        company_id: nil
      }

      min1=30
      max1=40
      min2=100
      max2=40

      {:ok,
       %{
         valid_attrs: valid_attrs,
         valid_attrs1: valid_attrs1,
         valid_attrs2: valid_attrs2,
         update_attrs: update_attrs,
         invalid_attrs: invalid_attrs,
         merchant1: merchant1,
         merchant2: merchant2,
         user1: user1,
         user2: user2,
         company1: company1,
         company2: company2,
         min1: min1,
         max1: max1,
         min2: min2,
         max2: max2
       }}
    end

    def transaction_fixture(valid_attrs, attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(valid_attrs)
        |> Transactions.create_transaction()

      transaction
    end

    test "list_transactions/1 returns all transactions", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert Transactions.list_transactions([]) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction", %{
      valid_attrs: valid_attrs,
      merchant1: merchant1,
      user1: user1,
      company1: company1
    } do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.amount == 42
      #assert transaction.credit == true
      assert transaction.debit == true
      assert transaction.credit == true
      assert transaction.description == "some description"
      assert transaction.merchant_id == merchant1.id
      assert transaction.user_id == user1.id
      assert transaction.company_id == company1.id
    end

    test "create_transaction/1 with invalid data returns error changeset", %{
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction", %{
      valid_attrs: valid_attrs,
      update_attrs: update_attrs,
      merchant2: merchant2,
      user2: user2,
      company2: company2
    } do
      transaction = transaction_fixture(valid_attrs)

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.amount == 43
      assert transaction.credit == false
      assert transaction.debit == false
      assert transaction.description == "some updated description"
      assert transaction.merchant_id == merchant2.id
      assert transaction.user_id == user2.id
      assert transaction.company_id == company2.id
    end

    test "update_transaction/2 with invalid data returns error changeset", %{
      valid_attrs: valid_attrs,
      invalid_attrs: invalid_attrs
    } do
      transaction = transaction_fixture(valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end

    test "get_transactions_in_range with valid min and max",  %{valid_attrs1: valid_attrs1, valid_attrs2: valid_attrs2, min1: min1, max1: max1} do
      transaction1 = transaction_fixture(valid_attrs1)
      transaction2 = transaction_fixture(valid_attrs2)
      assert Transactions.get_transactions_in_range!(min1, max1) == [transaction1, transaction2]
    end

    test "calculate_total_transactions with transactions between min and max",  %{valid_attrs1: valid_attrs1, valid_attrs2: valid_attrs2, min1: min1, max1: max1} do
      _transaction1 = transaction_fixture(valid_attrs1)
      _transaction2 = transaction_fixture(valid_attrs2)
      assert Transactions.calculate_total_transactions!(min1, max1) == 2
    end

    test "calculate_total_transactions with no transactions between min and max",  %{valid_attrs1: valid_attrs1, valid_attrs2: valid_attrs2, min2: min2, max2: max2} do
      _transaction1 = transaction_fixture(valid_attrs1)
      _transaction2 = transaction_fixture(valid_attrs2)
      assert Transactions.calculate_total_transactions!(min2, max2) == 0
    end

    test "get_transactions_with_pagination with transactions between min and max",  %{valid_attrs1: valid_attrs1, valid_attrs2: valid_attrs2, min1: min1, max1: max1} do
      _transaction1 = transaction_fixture(valid_attrs1)
      _transaction2 = transaction_fixture(valid_attrs2)
      _transaction3 = transaction_fixture(valid_attrs1)
      _transaction4 = transaction_fixture(valid_attrs1)

      limit=2
      page=1
      skip=1

      total= Transactions.calculate_total_transactions!(min1, max1)


      # Total 4 transactions, limit 2 and skip 1 . so 1st page should have 2 , 2nd page should have 1
      assert length(Transactions.get_transactions_with_pagination!(min1, max1, limit, page, total-skip)) == 2
      page=2
      assert length(Transactions.get_transactions_with_pagination!(min1, max1, limit, page, total-skip)) == 1
      page=3
      assert length(Transactions.get_transactions_with_pagination!(min1, max1, limit, page, total-skip)) == 0

      # Total 4 transactions, limit set to total no. of transactions and skip 1 . so 1st page should have 3 , 2nd page should have 0
      limit=total
      page=1
      assert length(Transactions.get_transactions_with_pagination!(min1, max1, limit, page, total-skip))== 3
      page=2
      assert length(Transactions.get_transactions_with_pagination!(min1, max1, limit, page, total-skip))== 0
    end
  end
end

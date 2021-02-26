defmodule Homework.Resolvers.TransactionsResolverTest do
  use Homework.DataCase

  alias Homework.Merchants
  alias Homework.Transactions
  alias Homework.Users
  alias Homework.Companies
  alias HomeworkWeb.Resolvers.TransactionsResolver

  describe "transactions" do

    test "transactions/3 returns all transactions" do

      {:ok, company} = Companies.create_company(%{
       name: "some name",
       available_credit: 5000,
       credit_line: 5000
       })

       {:ok, user} = Users.create_user(%{
           first_name: "John",
           last_name: "smith",
           dob: "08/04/1989"
       })

       {:ok, merchant} = Merchants.create_merchant(%{
           description: "some description",
           name: "Chocolate Factory"
       })

       # No transaction is created
       {:ok, transactions} = TransactionsResolver.transactions(nil, nil, nil)
       assert length(transactions) == 0

       # New transaction with below attributes is created

          Transactions.create_transaction(%{
           amount: 42,
           credit: true,
           debit: true,
           description: "some description",
           merchant_id: merchant.id,
           user_id: user.id,
           company_id: company.id
        })
        {:ok, transactions} = TransactionsResolver.transactions(nil, nil, nil)
        assert length(transactions) == 1
    end

    test "create_transaction/3 returns created transaction" do
       # No transaction is created
       {:ok, transactions} = TransactionsResolver.transactions(nil, nil, nil)
       assert length(transactions) == 0

       {:ok, company} = Companies.create_company(%{
        name: "some name",
        available_credit: 5000,
        credit_line: 5000
        })

        {:ok, user} = Users.create_user(%{
            first_name: "John",
            last_name: "smith",
            dob: "08/04/1989"
        })

        {:ok, merchant} = Merchants.create_merchant(%{
            description: "some description",
            name: "Chocolate Factory"
        })

       # New transaction with below attributes is created

        args = %{
           amount: 40,
           credit: true,
           debit: true,
           description: "some description",
           merchant_id: merchant.id,
           user_id: user.id,
           company_id: company.id
           }
      {:ok, transaction} = TransactionsResolver.create_transaction(nil, args, nil)
      assert transaction.amount == 40
      assert transaction.merchant_id == merchant.id

      # Invalid attributes for creating transaction
      # Invalid company id
      args1 = %{
         amount: 40,
         credit: true,
         debit: true,
         description: "some description",
         merchant_id: merchant.id,
         user_id: user.id,
         company_id: "2f005f74-52dd-4c27-b8b1-619504d11d93"
         }
      assert_raise Ecto.NoResultsError, fn ->
        TransactionsResolver.create_transaction(nil, args1, nil)
      end

      # Invalid user id
      args2 = %{
         amount: 40,
         credit: true,
         debit: true,
         description: "some description",
         merchant_id: merchant.id,
         user_id: "2f005f74-52dd-4c27-b8b1-619504d11d91",
         company_id: company.id
         }
      assert_raise Ecto.NoResultsError, fn ->
        TransactionsResolver.create_transaction(nil, args2, nil)
      end

      # Invalid merchant id
      args3 = %{
         amount: 40,
         credit: true,
         debit: true,
         description: "some description",
         merchant_id: "2f005f74-52dd-4c27-b8b1-619504d11d93",
         user_id: user.id,
         company_id: company.id
         }
      assert_raise Ecto.NoResultsError, fn ->
        TransactionsResolver.create_transaction(nil, args3, nil)
      end

      # Making big transaction
      args4 = %{
         amount: 4000,
         credit: true,
         debit: true,
         description: "some description",
         merchant_id: merchant.id,
         user_id: user.id,
         company_id: company.id
         }
      {:error, error} = TransactionsResolver.create_transaction(nil, args4, nil)
      assert error =~ "No credit available to make this transaction"
    end

    test "update_transaction/3 with different attributes" do
      {:ok, company} = Companies.create_company(%{
       name: "some name",
       available_credit: 5000,
       credit_line: 5000
       })

       {:ok, user} = Users.create_user(%{
           first_name: "John",
           last_name: "smith",
           dob: "08/04/1989"
       })

       {:ok, merchant} = Merchants.create_merchant(%{
           description: "some description",
           name: "Chocolate Factory"
       })

      # New transaction with below attributes is created

       args = %{
          amount: 40,
          credit: true,
          debit: true,
          description: "some description",
          merchant_id: merchant.id,
          user_id: user.id,
          company_id: company.id
          }
     {:ok, transaction} = TransactionsResolver.create_transaction(nil, args, nil)
     assert transaction.amount == 40
     assert transaction.merchant_id == merchant.id
      # New transaction with valid id attribute is created
      args_new = %{
         amount: 20,
         id: transaction.id
         }

       {:ok, transaction} = TransactionsResolver.update_transaction(nil, args_new, nil)
       assert transaction.amount == 20

       # New Transaction with invalid id is created -- expects Ecto.NoResultsError
        args_new = %{
          id: "2f005f74-52dd-4c27-b8b1-619504d11d93",
          amount: 20
        }

        assert_raise Ecto.NoResultsError, fn ->
          TransactionsResolver.update_transaction(nil, args_new, nil)
        end

        # New Transaction with nil id is created -- expects ArgumentError
         args_new = %{
           id: nil,
           amount: 20
         }

         assert_raise ArgumentError, fn ->
             TransactionsResolver.update_transaction(nil, args_new, nil)
         end
    end

    test "delete_transaction/3  with different attributes" do
      {:ok, company} = Companies.create_company(%{
       name: "some name",
       available_credit: 4000,
       credit_line: 5000
       })

       {:ok, user} = Users.create_user(%{
           first_name: "John",
           last_name: "smith",
           dob: "08/04/1989"
       })

       {:ok, merchant} = Merchants.create_merchant(%{
           description: "some description",
           name: "Chocolate Factory"
       })

      # New transaction with below attributes is created

       args = %{
          amount: 10,
          credit: true,
          debit: true,
          description: "some description",
          merchant_id: merchant.id,
          user_id: user.id,
          company_id: company.id
          }
     {:ok, transaction} = TransactionsResolver.create_transaction(nil, args, nil)
     assert transaction.amount == 10
     assert transaction.merchant_id == merchant.id
      # New Transaction with valid id attribute is created
      args_new = %{
         id: transaction.id
      }

      {:ok, del_transaction} = TransactionsResolver.delete_transaction(nil, args_new, nil)
      assert del_transaction.id == transaction.id

      # New Transaction with invalid id is created -- expects Ecto.NoResultsError
      args = %{
        id: "2f005f74-52dd-4c27-b8b1-619504d11d93"
      }

      assert_raise Ecto.NoResultsError, fn ->
        TransactionsResolver.update_transaction(nil, args, nil)
      end

      # New Transaction with nil id is created -- expects ArgumentError
      args = %{
        id: nil
      }

      assert_raise ArgumentError, fn ->
        TransactionsResolver.delete_transaction(nil, args, nil)
      end
    end

    test "get_transactions_in_range/3  with different attributes" do
      {:ok, company} = Companies.create_company(%{
       name: "some name",
       available_credit: 4000,
       credit_line: 5000
       })

       {:ok, user} = Users.create_user(%{
           first_name: "John",
           last_name: "smith",
           dob: "08/04/1989"
       })

       {:ok, merchant} = Merchants.create_merchant(%{
           description: "some description",
           name: "Chocolate Factory"
       })

      # New transaction with below attributes is created

       args1 = %{
          amount: 10,
          credit: true,
          debit: true,
          description: "some description",
          merchant_id: merchant.id,
          user_id: user.id,
          company_id: company.id
          }
        args2 = %{
           amount: 11,
           credit: true,
           debit: true,
           description: "some description",
           merchant_id: merchant.id,
           user_id: user.id,
           company_id: company.id
           }
         args3 = %{
            amount: 13,
            credit: true,
            debit: true,
            description: "some description",
            merchant_id: merchant.id,
            user_id: user.id,
            company_id: company.id
            }
       {:ok, transaction1} = TransactionsResolver.create_transaction(nil, args1, nil)
       {:ok, transaction2} = TransactionsResolver.create_transaction(nil, args2, nil)
       {:ok, transaction3} = TransactionsResolver.create_transaction(nil, args3, nil)
       {:ok, transactions} = TransactionsResolver.get_transactions_in_range(nil,%{min: 10, max: 13} , nil)
       assert transactions == [transaction1, transaction2, transaction3]

       {:ok, transactions} = TransactionsResolver.get_transactions_in_range(nil,%{min: 50, max: 100} , nil)
       assert transactions == []
     end

     test "get_transactions_with_pagination/3  with different attributes" do
       {:ok, company} = Companies.create_company(%{
        name: "some name",
        available_credit: 9000,
        credit_line: 9000
        })

        {:ok, user} = Users.create_user(%{
            first_name: "John",
            last_name: "smith",
            dob: "08/04/1989"
        })

        {:ok, merchant} = Merchants.create_merchant(%{
            description: "some description",
            name: "Chocolate Factory"
        })

       # New transaction with below attributes is created

        args1 = %{
           amount: 10,
           credit: true,
           debit: true,
           description: "some description",
           merchant_id: merchant.id,
           user_id: user.id,
           company_id: company.id
           }
         args2 = %{
            amount: 11,
            credit: true,
            debit: true,
            description: "some description",
            merchant_id: merchant.id,
            user_id: user.id,
            company_id: company.id
            }
          args3 = %{
             amount: 13,
             credit: true,
             debit: true,
             description: "some description",
             merchant_id: merchant.id,
             user_id: user.id,
             company_id: company.id
             }
          args4 = %{
              amount: 15,
              credit: true,
              debit: true,
              description: "some description",
              merchant_id: merchant.id,
              user_id: user.id,
              company_id: company.id
              }
        {:ok, _transaction1} = TransactionsResolver.create_transaction(nil, args1, nil)
        {:ok, _transaction2} = TransactionsResolver.create_transaction(nil, args2, nil)
        {:ok, _transaction3} = TransactionsResolver.create_transaction(nil, args3, nil)
        {:ok, _transaction4} = TransactionsResolver.create_transaction(nil, args4, nil)

        {:ok, result} = TransactionsResolver.get_transactions_with_pagination(nil, %{min: 10, max: 15, limit: 2, page: 1, skip: 0} , nil)
        assert length(result.list) == 2

        {:ok, result} = TransactionsResolver.get_transactions_with_pagination(nil, %{min: 10, max: 15, limit: 2, page: 2, skip: 1} , nil)
        assert length(result.list) == 1
      end
  end
end

defmodule HomeworkWeb.Schemas.TransactionsSchema do
  @moduledoc """
  Defines the graphql schema for transactions.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.TransactionsResolver

  object :result do
    field(:total_results, :integer)
    field(:list, list_of(:transaction))
  end

  object :transaction do
    field(:id, non_null(:id))
    field(:user_id, :id)
    @desc "amount is in dollars"
    field(:amount, :float)
    field(:credit, :boolean)
    field(:debit, :boolean)
    field(:description, :string)
    field(:merchant_id, :id)
    field(:company_id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    field(:user, :user) do
      resolve(&TransactionsResolver.user/3)
    end

    field(:merchant, :merchant) do
      resolve(&TransactionsResolver.merchant/3)
    end

    field(:company, :company) do
      resolve(&TransactionsResolver.company/3)
    end
  end

  object :transaction_mutations do
    @desc "Create a new transaction"
    field :create_transaction, :transaction do
      arg(:user_id, non_null(:id))
      arg(:merchant_id, non_null(:id))
      arg(:company_id, non_null(:id))
      @desc "amount is in dollars"
      arg(:amount, non_null(:float))
      arg(:credit, :boolean)
      arg(:debit, :boolean)
      arg(:description, non_null(:string))

      resolve(&TransactionsResolver.create_transaction/3)
    end

    @desc "Update a new transaction"
    field :update_transaction, :transaction do
      arg(:id, non_null(:id))
      arg(:user_id, :id)
      arg(:merchant_id, :id)
      arg(:company_id, :id)
      @desc "amount is in dollars"
      arg(:amount, :float)
      arg(:credit, :boolean)
      arg(:debit, :boolean)
      arg(:description, :string)

      resolve(&TransactionsResolver.update_transaction/3)
    end

    @desc "delete an existing transaction"
    field :delete_transaction, :transaction do
      arg(:id, non_null(:id))

      resolve(&TransactionsResolver.delete_transaction/3)
    end

    @desc "Search transactions with in range"
    field :get_transactions_in_range, list_of(:transaction) do
      arg(:min, non_null(:float))
      arg(:max, non_null(:float))
      resolve(&TransactionsResolver.get_transactions_in_range/3)
    end

    @desc "Search transactions with in range pagination"
    field :get_transactions_with_pagination, :result do
      arg(:min, non_null(:float))
      arg(:max, non_null(:float))
      arg(:limit, :integer)
      arg(:page, :integer, default_value: 1)
      arg(:skip, :integer, default_value: 0)
      resolve(&TransactionsResolver.get_transactions_with_pagination/3)
    end
  end
end

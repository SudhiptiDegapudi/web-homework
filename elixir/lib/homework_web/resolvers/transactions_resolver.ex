defmodule HomeworkWeb.Resolvers.TransactionsResolver do
  alias Homework.Merchants
  alias Homework.Transactions
  alias Homework.Users
  alias Homework.Companies
  alias Homework.Pagination

  @doc """
  Get a list of transcations
  """
  def transactions(_root, args, _info) do
    transactions =  Transactions.list_transactions(args)
    transactions = Enum.map(transactions, fn trans-> %{trans | amount: trans.amount/100} end)
    {:ok, transactions}
      {:ok, transactions}
  end

  @doc """
  Get the user associated with a transaction
  """
  def user(_root, _args, %{source: %{user_id: user_id}}) do
    {:ok, Users.get_user!(user_id)}
  end

  @doc """
  Get the merchant associated with a transaction
  """
  def merchant(_root, _args, %{source: %{merchant_id: merchant_id}}) do
    {:ok, Merchants.get_merchant!(merchant_id)}
  end

  @doc """
  Get the company associated with a transaction
  """
  def company(_root, _args, %{source: %{company_id: company_id}}) do
    {:ok, Companies.get_company!(company_id)}
  end

  @doc """
  Create a new transaction
  """
  def create_transaction(_root, args, _info) do
      company = Companies.get_company!(args.company_id)
      _merchant = Merchants.get_merchant!(args.merchant_id)
      _user = Users.get_user!(args.user_id)
      args = %{args | amount: trunc(args.amount*100)}
      if company.available_credit < args.amount do
        {:error, "No credit available to make this transaction"}
      else
        case Transactions.create_transaction(args) do
          {:ok, transaction} ->
            _company = update_company_details(args.amount, company)
            transaction = %{transaction | amount: transaction.amount/100}
            {:ok, transaction}
        error ->
          {:error, "could not create transaction: #{inspect(error)}"}
        end
      end
  end

  @doc """
  Updates a transaction for an id with args specified.
  """
  def update_transaction(_root, %{id: id} = args, _info) do
    transaction = Transactions.get_transaction!(id)
    company = Companies.get_company!(transaction.company_id)
    args = %{args | amount: trunc(args.amount*100)}
    diff_amount = args.amount-transaction.amount
    if diff_amount>0 && diff_amount > company.available_credit do
      {:error, "No credit available to make this transaction"}
    else
      case Transactions.update_transaction(transaction, args) do
        {:ok, transaction} ->
          _company = update_company_details(diff_amount, company)
          transaction = %{transaction | amount: transaction.amount/100}
          {:ok, transaction}
        error ->
          {:error, "could not update transaction: #{inspect(error)}"}
      end
    end
  end

  @doc """
  Deletes a transaction for an id
  """
  def delete_transaction(_root, %{id: id}, _info) do
    transaction = Transactions.get_transaction!(id)
    company = Companies.get_company!(transaction.company_id)
    case Transactions.delete_transaction(transaction) do
      {:ok, transaction} ->
        _company = update_company_details(-transaction.amount, company)
        transaction = %{transaction | amount: transaction.amount/100}
        {:ok, transaction}

      error ->
        {:error, "could not update transaction: #{inspect(error)}"}
    end
  end

  @doc """
  get transactions with in a range.
  """
  def get_transactions_in_range(_root, %{min: min, max: max}, _info) do
    min = trunc(min*100)
    max = trunc(max*100)
    transactions =  Transactions.get_transactions_in_range!(min, max)
    transactions = Enum.map(transactions, fn trans-> %{trans | amount: trans.amount/100} end)
    {:ok, transactions}
  end

  @doc """
  get transactions with pagination with in a range.
  """
  def get_transactions_with_pagination(_root, %{min: min, max: max, limit: limit, page: page, skip: skip}, _info) do
    min = trunc(min*100)
    max = trunc(max*100)
    total_results = Transactions.calculate_total_transactions!(min, max)
    ## Find the right page number
    page_no = Pagination.find_page_no( page, total_results, limit)
    transactions = Transactions.get_transactions_with_pagination!(min, max, limit, page_no, total_results, skip)
    transactions = Enum.map(transactions, fn trans-> %{trans | amount: trans.amount/100} end)
    result = %{total_results: total_results, list: transactions}
    {:ok, result}
  end

  #Updates a company available credit based on transactions for an id with args specified.
  defp update_company_details(amount, company) do
    _updated = Companies.update_company(company, %{id: company.id, available_credit: company.available_credit-amount})
  end

end

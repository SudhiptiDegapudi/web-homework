defmodule Homework.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Transactions.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions([])
      [%Transaction{}, ...]

  """
  def list_transactions(_args) do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def get_transactions_in_range!(min, max) do
    from(
      trans in Transaction,
      where: fragment("? BETWEEN ? AND ? ", trans.amount, ^min, ^max),
      order_by: fragment("? DESC", trans.inserted_at)
    )
    |> Repo.all()
  end

  def get_transactions_with_pagination!(min, max, limit, page, total_results, skip) do
    count = total_results-skip
    sub_query = from trans in Transaction,
                order_by: [desc: trans.inserted_at],
                where: trans.amount >= ^min and trans.amount <= ^max,
                limit: ^count,
                select: trans
    query = from trans in subquery(sub_query),limit: ^limit, offset: (^page - 1) * ^limit, select: trans
    Repo.all(query)
  end

  def calculate_total_transactions!(min, max) do
    from(
      trans in Transaction,
      where: fragment("? BETWEEN ? AND ? ", trans.amount, ^min, ^max)
    )
    |> Repo.aggregate( :count, :id)
  end
end

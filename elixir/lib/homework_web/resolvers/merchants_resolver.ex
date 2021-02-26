defmodule HomeworkWeb.Resolvers.MerchantsResolver do
  alias Homework.Merchants

  @doc """
  Get a list of merchants
  """
  def merchants(_root, args, _info) do
    {:ok, Merchants.list_merchants(args)}
  end

  @doc """
  Create a new merchant
  """
  def create_merchant(_root, args, _info) do
    case Merchants.create_merchant(args) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not create merchant: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a merchant for an id with args specified.
  """
  def update_merchant(_root, %{id: id} = args, _info) do
    merchant = Merchants.get_merchant!(id)

    case Merchants.update_merchant(merchant, args) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not update merchant: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a merchant for an id
  """
  def delete_merchant(_root, %{id: id}, _info) do
    merchant = Merchants.get_merchant!(id)

    case Merchants.delete_merchant(merchant) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not delete merchant: #{inspect(error)}"}
    end
  end


  @doc """
  Search a merchant with args specified.
  """
  def search_merchant_by_name(_root, %{name: name}, _info) do
    {:ok, Merchants.search_merchant_by_name!(name)}
  end

end

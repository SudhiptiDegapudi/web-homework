defmodule Homework.Merchants do
  @moduledoc """
  The Merchants context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Merchants.Merchant

  @doc """
  Returns the list of merchants.

  ## Examples

      iex> list_merchants([])
      [%Merchant{}, ...]

  """
  def list_merchants(_args) do
    Repo.all(Merchant)
  end

  @doc """
  Gets a single merchant.

  Raises `Ecto.NoResultsError` if the Merchant does not exist.

  ## Examples

      iex> get_merchant!(123)
      %Merchant{}

      iex> get_merchant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_merchant!(id), do: Repo.get!(Merchant, id)

  @doc """
  Creates a merchant.

  ## Examples

      iex> create_merchant(%{field: value})
      {:ok, %Merchant{}}

      iex> create_merchant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_merchant(attrs \\ %{}) do
    %Merchant{}
    |> Merchant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a merchant.

  ## Examples

      iex> update_merchant(merchant, %{field: new_value})
      {:ok, %Merchant{}}

      iex> update_merchant(merchant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_merchant(%Merchant{} = merchant, attrs) do
    merchant
    |> Merchant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a merchant.

  ## Examples

      iex> delete_merchant(merchant)
      {:ok, %Merchant{}}

      iex> delete_merchant(merchant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_merchant(%Merchant{} = merchant) do
    Repo.delete(merchant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking merchant changes.

  ## Examples

      iex> change_merchant(merchant)
      %Ecto.Changeset{data: %Merchant{}}

  """
  def change_merchant(%Merchant{} = merchant, attrs \\ %{}) do
    Merchant.changeset(merchant, attrs)
  end


## assignment
  def search_by_name!(name) do
    start_character = String.slice(name, 0..1)
    from(
      p in Merchant,
      where: ilike(p.name, ^"#{start_character}%"),
      where: fragment("SIMILARITY(?, ?) > 0",  p.name, ^name),
      order_by: fragment("LEVENSHTEIN(?, ?)", p.name, ^name)
    )
    |> Repo.all()
  end
end

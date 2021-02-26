defmodule HomeworkWeb.Schemas.CompaniesSchema do
  @moduledoc """
  Defines the graphql schema for companies.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.CompaniesResolver

  object :company do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:credit_line, :integer)
    @desc "available_credit is in dollars"
    field(:available_credit, :float)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end

  object :company_mutations do
    @desc "Create a new company"
    field :create_company, :company do
      arg(:name, non_null(:string))
      @desc "credit_line is in cents"
      arg(:credit_line, non_null(:integer))
      arg(:available_credit, non_null(:float))

      resolve(&CompaniesResolver.create_company/3)
    end

    @desc "Update a new company"
    field :update_company, :company do
      arg(:id, non_null(:id))
      arg(:name, :string)
      @desc "credit_line is in cents"
      arg(:credit_line, :integer)
      arg(:available_credit, :float)

      resolve(&CompaniesResolver.update_company/3)
    end

    @desc "delete an existing company"
    field :delete_company, :company do
      arg(:id, non_null(:id))
      resolve(&CompaniesResolver.delete_company/3)
    end
  end
end

defmodule HomeworkWeb.Schemas.CompaniesSchema do
  @moduledoc """
  Defines the graphql schema for companies.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.CompaniesResolver

  object :company do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    @desc "creditLine is in cents"
    field(:credit_line, :integer)
    @desc "availableCredit is in cents"
    field(:available_credit, :integer)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end

  object :company_mutations do
    @desc "Create a new company"
    field :create_company, :company do
      arg(:name, non_null(:string))
      @desc "creditLine is in cents"
      arg(:credit_line, non_null(:integer))
      @desc "availableCredit is in cents"
      arg(:available_credit, non_null(:integer))

      resolve(&CompaniesResolver.create_company/3)
    end

    @desc "Update a new company"
    field :update_company, :company do
      arg(:id, non_null(:id))
      arg(:name, :string)
      @desc "creditLine is in cents"
      arg(:credit_line, :integer)
      @desc "availableCredit is in cents"
      arg(:available_credit, :integer)

      resolve(&CompaniesResolver.update_company/3)
    end

    @desc "delete an existing company"
    field :delete_company, :company do
      arg(:id, non_null(:id))
      resolve(&CompaniesResolver.delete_company/3)
    end
  end
end

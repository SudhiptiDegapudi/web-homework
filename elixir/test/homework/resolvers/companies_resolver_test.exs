defmodule Homework.Resolvers.CompaniesResolverTest do
  use Homework.DataCase

  alias Homework.Companies
  alias HomeworkWeb.Resolvers.CompaniesResolver

  describe "companies" do


    test "companies/3 returns all companies" do
     # No company is created
     {:ok, companies} = CompaniesResolver.companies(nil, nil, nil)
     assert length(companies) == 0

     # New Company with below attributes is created
       Companies.create_company(%{
        name: "some name",
        available_credit: 5000,
        credit_line: 5000
      })
      {:ok, companies} = CompaniesResolver.companies(nil, nil, nil)
      assert length(companies) == 1
    end

    test "create_company/3 returns created company" do
     # No company is created
     {:ok, companies} = CompaniesResolver.companies(nil, nil, nil)
     assert length(companies) == 0

     # New Company with below attributes is created
      args = %{
        name: "some name",
        available_credit: 5000,
        credit_line: 5000
      }
      {:ok, company} = CompaniesResolver.create_company(nil, args, nil)
      assert company.name == "some name"
    end

    test "create_company/3 returns error with invalid attributes" do
      # New Company with invalid attributes is created
       args = %{
         name: nil,
         available_credit: 5000,
         credit_line: 5000
       }

       {:error, error} = CompaniesResolver.create_company(nil, args, nil)
       assert error =~ "could not create company"
    end

    test "update_company/3 with different attributes" do
      {:ok, company}  = Companies.create_company(%{
        name: "some name",
        available_credit: 5000,
        credit_line: 5000
      })
      # New Company with valid id attribute is created
       args = %{
         id: company.id,
         available_credit: 3000
       }

       {:ok, company} = CompaniesResolver.update_company(nil, args, nil)
       assert company.available_credit == 3000

       # New Company with invalid id is created -- expects Ecto.NoResultsError
        args = %{
          id: "2f005f74-52dd-4c27-b8b1-619504d11d93",
          available_credit: 3000
        }

        assert_raise Ecto.NoResultsError, fn ->
          CompaniesResolver.update_company(nil, args, nil)
        end

        # New Company with nil id is created -- expects ArgumentError
         args = %{
           id: nil,
           available_credit: 3000
         }

         assert_raise ArgumentError, fn ->
           CompaniesResolver.update_company(nil, args, nil)
         end
    end


    test "delete_company/3 returns error with different attributes" do
      {:ok, company}  = Companies.create_company(%{
        name: "some name",
        available_credit: 5000,
        credit_line: 5000
      })
      # New Company with valid id attribute is created
       args = %{
         id: company.id
       }

       {:ok, del_company} = CompaniesResolver.delete_company(nil, args, nil)
       assert del_company.id == company.id

       # New Company with invalid id is created -- expects Ecto.NoResultsError
        args = %{
          id: "2f005f74-52dd-4c27-b8b1-619504d11d93"
        }

        assert_raise Ecto.NoResultsError, fn ->
          CompaniesResolver.update_company(nil, args, nil)
        end

        # New Company with nil id is created -- expects ArgumentError
         args = %{
           id: nil
         }

         assert_raise ArgumentError, fn ->
           CompaniesResolver.delete_company(nil, args, nil)
         end
    end

  end
end


Process followed to run the Application
1) mix setup - To install dependencies and seed data into database.
   Running this command multiple times might create duplicate records or give errors with duplicate constraints. In order to fix this , I made changes to the mix setup to drop database first and run it again.
   Note : DB application is connected to is homework_dev
2) Start phoenix server
3) I have used seed file to create initial users, merchants and companies. Transactions should be created with the info from these tables.

Assumptions :

1) All the tests are connected to homework_test. Changed the db name in test config file.
2) Transactions paginated returns the total transactions after skipping the desired records.
3) For fuzzy search on users and merchants , case sensitivity is ignored , any case brings results as its going to be tedious for user.
4) Companies input and output will be displayed in cents when testing endpoints .

Running Test cases:
1) Navigated to elixir directory under project and used command to run all test cases - mix test test/homework.


Info for creating transactional data:

Amount is in dollars
mutation {
  createTransaction(amount: 3, credit :true, debit:true,description:"trans1",
  merchantId:"7ed355e5-cf61-46a6-8d89-e58e2d9f13ca",
    userId:"5b30fd5d-2a54-410c-a1a0-8ec625776a3b",
    companyId:"a77877d2-994c-4797-b34a-160d7cac17e6") {
    amount
    merchantId
    userId
  }
}

creditLine and availableCredit is in cents
mutation {
  createCompany(creditLine: 5000, name: "company1", availableCredit :5000) {
    id
    availableCredit
    creditLine
  }
}


availableCredit in cents
creditLine in cents

{
  companies {
    availableCredit
    creditLine
    id
  }
}

mutation {
  getTransactionsInRange(min: 12, max:50) {
    amount
    merchantId
    userId
  }
}

mutation {
  searchUserByName(name: "BRENT") {
    lastName
    firstName		
  }
}

mutation {
  getTransactionsWithPagination(page:1, min: 19, max: 50, limit: 2, skip: 0) {
    totalResults
    list {
      id
    }
  }
}

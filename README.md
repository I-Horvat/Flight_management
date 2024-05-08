# Flight Management API

How to run:

1. Clone the repository
2. Run `bundle install`
3. Run `rails db:create`
4. Run `rails db:migrate`
5. Run `rails s`
6. Open `http://localhost:3000` in your browser

## Versions
- Ruby version: 2.6.3
- Rails version: 6.0.x
- Other gem dependencies as specified in the Gemfile

## Database Creation
- Run `rails db:create` to create the necessary databases for the application.

## Database Initialization
- Run `rails db:migrate` to initialize the database schema.

## Running Tests
- To run the test suite using RSpec, navigate to the project directory in the terminal and run:
- `bundle exec rspec`

## Running Rails Server
- To start the Rails server and run the API, navigate to the project directory in the terminal and run:
- `rails s`
- Open `http://localhost:3000` in your browser to access the API.
- The API can be accessed using tools like Postman or cURL.


# UsersController

## Description
The UsersController manages user-related tasks, including user creation, retrieval, updating, and deletion.

## Endpoints
- **Create User:** `POST /api/users`
- **Get All Users:** `GET /api/users`
- **Get User by ID:** `GET /api/users/:id`
- **Update User:** `PUT /api/users/:id`
- **Delete User:** `DELETE /api/users/:id`

### Additional Endpoint
- **Update User Role:** `PUT /api/users/:id/update_role`

## Authentication
- Authentication is required for all actions except for user creation.
- Token-based authentication is used.

# CompaniesController

## Description
This controller manages operations related to companies, including creation, retrieval, updating, and deletion.

## Endpoints
- **Create Company:** `POST /api/companies`
- **Get All Companies:** `GET /api/companies`
- **Get Company by ID:** `GET /api/companies/:id`
- **Update Company:** `PUT /api/companies/:id`
- **Delete Company:** `DELETE /api/companies/:id`

## Authentication
- The user must be authenticated to perform all actions except for viewing companies.
- Token-based authentication is used.

# FlightsController

## Description
This controller handles operations concerning flights, such as creation, retrieval, updating, and deletion.

## Endpoints
- **Create Flight:** `POST /api/flights`
- **Get All Flights:** `GET /api/flights`
- **Get Flight by ID:** `GET /api/flights/:id`
- **Update Flight:** `PUT /api/flights/:id`
- **Delete Flight:** `DELETE /api/flights/:id`

## Authentication
- Authentication is required for all actions except for retrieving flights.
- Token-based authentication is implemented.
# CompaniesController

## Description
This controller manages operations related to companies, including creation, retrieval, updating, and deletion.

## Endpoints
- **Create Company:** `POST /api/companies`
- **Get All Companies:** `GET /api/companies`
- **Get Company by ID:** `GET /api/companies/:id`
- **Update Company:** `PUT /api/companies/:id`
- **Delete Company:** `DELETE /api/companies/:id`

## Authentication
- The user must be authenticated to perform all actions except for viewing companies.
- Token-based authentication is used.


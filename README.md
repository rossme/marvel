# Marvel Comics API

This application demonstrates various technical abilities using the Marvel API [https://developer.marvel.com/](https://developer.marvel.com/)

It uses API rate limiting, caching, testing with RSpec, VCR, and Webmock.

### Setup

- **Framework**: This application uses Ruby 3.1.2 and Rails 7.2.1
- **Installation**: To install the application, run `bundle install`
- **Database**: To create the database, run `rails db:create`
- **Migrations**: To run the migrations, run `rails db:migrate`
- **Seed Data**: To seed the database, run `rails db:seed`

- **Environment Variables**: This application uses Rails credentials to store the Marvel API keys.
  - To set the credentials, run `EDITOR="nano" rails credentials:edit`
  - Add the following keys:
    ```yaml
    marvel:
      private_key: YOUR_PRIVATE_KEY
      public_key: YOUR_PUBLIC_KEY
    ```
  - Save and close the file

- **Running the Application**:
  - To run the application, use the command `rails s`
  - The application is hosted on `http://localhost:3000`
- **Internal API**:
  - The API is hosted on `http://localhost:3000/api/v1`
  - The API has two endpoints: `/comics` and `/comics/:character_id`
  - The API is versioned and follows RESTful conventions
- **Testing**: RSpec, VCR, Webmock, FactoryBot, Rack Mini Profiler
  - To run the tests, use the command `rspec`
  - HTTP interactions have been recorded using VCR and Webmock
  - The tests cover the service object requests, controller, API/v1 endpoints and external API requests
  - The credentials have been filtered out of the VCR cassettes
- **Database**: This application uses SQLite3

### Key features

- **VCR and Webmock**: Replay external HTTP interactions.
- **API Rate Limit Middleware**: The application is rate-limited.
  - Faraday Middleware The application uses a custom middleware to handle API rate limiting.
  - The rate limit is set to 1000 requests in a 24-hour period for each user.
- **API caching**: Caching is used to store the latest comics fetched from the Marvel API.
  - The cache is cleared every 24 hours.
  - Caching is used for both retrieving the latest comics and fetching comics by character.
  - This speeds up the application and reduces the number of requests to the Marvel API.
- **RSPec Testing**: There are extensive tests using RSpec and VCR.
  - The tests cover the service object requests, controller, API/v1 endpoints and external API requests.
- **Grape API**: The endpoints in the application use Grape API.
  - The API is versioned and follows RESTful conventions.
- **Marvel API**: The application fetches data from the Marvel API.

### Middleware

- **API Rate Limit Middleware**: This middleware helps limit and manage external API requests, preventing rate limits from being exceeded. It fetches user session information and keeps track of the number of external API requests the user has made in a 24-hour period. If the limit is reached, further requests are blocked.

### Caching

- **Rails Caching**: The Marvel API requests are cached to improve performance. The cache is cleared every 24 hours.

### Devise

A default fake user is assigned to the session, simplifying the application's use. The user is automatically logged in when the application is accessed.

### Libraries

This application relies on several Ruby gems to enhance its functionality:

- **GrapeAPI**: The Grape gem is used to create the API endpoints.
- **Faraday**: This gem is used to make HTTP requests to the Marvel API.
- **VCR and Webmock**: These gems are used to replay external HTTP interactions.
- **Rack mini profiler**: This gem is used to profile the application's performance.
- **Tailwind**: This gem is used to style the application.
- **simplecov**: This gem is used to track test coverage.
- **Rspec**: Extensive testing is ensured using RSpec.
- **Factorybot Rails**: This gem facilitates testing by providing factories for generating test data.
- **Devise**: This gem handles user sessions and authentication.
- **Stimulus**: This gem is used to add interactivity to the application, keeping the views lightweight.

### VCR and Webmock Testing

VCR and Webmock are used to replay external HTTP interactions. This allows the application to run tests without making actual requests to the Marvel API.

### Why only one Model?
- This application has one model, User.
- This is because the application is only designed to fetch and display comics from the Marvel API.
- The User model is an effective way to store the user's session information and manage the API rate limit middleware.

### Why use Grape API?
- Grape is a lightweight API framework that allows for easy creation of API endpoints.

### Why use Faraday?
- Faraday is a flexible HTTP client library that allows for easy handling of HTTP requests.

### Why use VCR and Webmock?
- VCR and Webmock are used to replay external HTTP interactions, allowing for testing without making actual requests to the Marvel API.
- Sensitive information is filtered out of the VCR cassettes.

### Why use Cache?
- Caching is used to store the latest comics fetched from the Marvel API.

### Why store favourite comics in the session?
- Favourite comics are stored in the application session to simplify the application's use.

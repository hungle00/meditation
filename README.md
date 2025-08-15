## Meta's Thread-like Feature
A Ruby on Rails API application that mimics Meta's Thread platform with social media features like posts, comments, voting, and user interactions.  
This project is generate by Cursor AI.

## Technical Stack

- **Ruby on Rails 8.0.2**: Main backend framework (API mode)
- **SQLite**: Default development database
- **JWT** + **Bcrypt**: Authentication
- **RSpec + FactoryBot**: Comprehensive testing framework
- **Rswag**: Interactive API documentation with Swagger UI
- **Jbuilder**: JSON view templates for clean API responses
- **Rubocop**: Code style and quality enforcement

### Features
- **User Authentication**: Registration and login with JWT tokens
- **Thread Posts**: Create, read, update, delete thread posts
- **Comments**: Nested comments with reply functionality
- **Voting**: Upvote threads and comments (polymorphic)
- **API Documentation**: Interactive Swagger UI at `/api-docs`
- **Pagination**: Thread listing with Kaminari pagination

## Getting Started

### Prerequisites
- Ruby 3.3.5+
- Rails 8.0.2+
- SQLite3

### Installation
```bash
# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start the server
rails server
```

### Testing
```bash
# Run all tests
bundle exec rspec

# Generate Swagger documentation
bundle exec rails rswag:specs:swaggerize

# Run code quality checks
bundle exec rubocop
```

## API Endpoints

### Public Endpoints
- `GET /home` - List all thread posts with pagination
- `GET /thread_posts` - List thread posts
- `GET /thread_posts/:id` - Show specific thread post
- `GET /thread_posts/:id/comments` - List comments for a thread

### Protected Endpoints (JWT Required)
- `POST /register` - User registration
- `POST /login` - User authentication
- `POST /thread_posts` - Create new thread post
- `PUT /thread_posts/:id` - Update thread post
- `DELETE /thread_posts/:id` - Delete thread post
- `POST /thread_posts/:id/comments` - Add comment to thread
- `DELETE /comments/:id` - Delete comment

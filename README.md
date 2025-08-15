## Meta's Thread-like Feature
This project is Meta's Thread-like application, generate by Cursor AI.

### Technical Stack
- **Ruby on Rails**: Main backend framework (API mode)
- **SQLite**: Default development database
- **RSpec + Rswag**: API testing and Swagger documentation
- **JWT**: Authentication for protected endpoints
- **Bcrypt**: Secure password hashing

### Features
- **User Authentication**: Registration and login with JWT tokens
- **Thread Posts**: Create, read, update, delete thread posts
- **Comments**: Nested comments with reply functionality
- **Voting System**: Upvote threads and comments (polymorphic)
- **API Documentation**: Interactive Swagger UI at `/api-docs`
- **Pagination**: Thread listing with Kaminari pagination
- **Rate Limiting**: Custom middleware for API protection
- **Testing**: Comprehensive RSpec tests with factories


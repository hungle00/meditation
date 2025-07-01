## Meta's Thread-like Feature
This project is Meta's Thread-like application, generate by Cursor AI.

### Technical Stack
- **Ruby on Rails**: Main backend framework (API mode)
- **SQLite**: Default development database
- **RSpec + Rswag**: API testing and Swagger documentation
- **JWT**: Authentication for protected endpoints
- **Bcrypt**: Secure password hashing

### Models and Relationships

- **User**: Has many threads (ThreadPost), has many comments, has many votes
- **ThreadPost**: Belongs to a user, has many comments, has many votes (as votable, polymorphic)
- **Comment**: Belongs to a thread_post and a user, can have many subcomments (self-referential association), has many votes (as votable, polymorphic)
- **Vote**: Belongs to a user, belongs to a votable (polymorphic: ThreadPost or Comment)

See the migrations in `db/migrate` for details.

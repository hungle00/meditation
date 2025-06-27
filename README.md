## Meta's Thread-like Feature
This project is Meta's Thread-like application, generate by Cursor AI, 

### Models and Relationships

- **User**: Has many threads (ThreadPost)
- **ThreadPost**: Belongs to a user, has many comments
- **Comment**: Belongs to a thread_post and a user, can have many subcomments (self-referential association)

### Database Tables
- `users`: name, email
- `thread_posts`: user_id, title, content
- `comments`: thread_post_id, user_id, parent_id, content

See the migrations in `db/migrate` for details.

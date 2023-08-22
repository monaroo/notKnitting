# NotKnitting

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


Entity-Relationship diagram :
erDiagram
    User |o--o{ Pattern : o
    Pattern ||--o{ Comment : o
    Pattern }o--o{ Tag : o
    Pattern ||--|| Image : o
    User {
        string username
        string email
        string password
    }
    Pattern {
        string title
        string content
        int pattern_id
        datetime published_on 
    }
    Comment {
        string username
        string content
        int pattern_id
    }
    Tag {
        string name

    }
    Image {
        string url
        int post_id
    }
    User |o--o{ Message : o
    Message {
        string productCode
        int quantity
        float pricePerUnit
    }

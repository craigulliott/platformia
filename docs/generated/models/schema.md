For databases which support it (such as `postgres`), this is the
name of the postgres servers database schema where the data for
this model will be persisted. If you do not provide a schema name,
then the default schema (usually `public`) will be used.

It is reccomended that all models which are within a namespace
be placed in their own schema. For example.

```ruby
# All of our model classes extend from PlatformModel.
class PlatformModel
  # A default database server configuration for all models in
  # the platform to use
  # and the default database on that server
  database :postgres, :primary
end

# A base class within the Users namespace for all Users models
# to extend from.
class Users::UsersModel
  # all models within the Usrs namespace should be stored
  # in the "users" schema within our database
  schema :users

  # optionally, you could call `database` again here and it
  # would change the server and/or database which would be
  # used for only the models within the Users namespace
end

# Both of these models will be stored in the `users` schema
# in our database (`users`.`users` and `users`.`avatars`).
class Users:UserModel < UsersModel
  ...
end
class Users:AvatarModel < UsersModel
  ...
end
```

```ruby
class MyModel < PlatformModel
  schema :schema_name
end

```

**Arguments**

schema\_name (required Symbol)
:   The name of the schema to use.
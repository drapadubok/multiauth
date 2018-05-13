# Multiauth: an etude on authentication in Phoenix (web framework in Elixir programming language).

## Why did I work on this?
It's been a few months that I started learning Elixir.
I started because I had one use case at work with Python, where I needed to parallelize a ton of IO operations, and I used a combination of multiprocessing and gevent to speed things up. It was quite a pain at first, and as I was reading on how to do this correctly, Erland and Elixir showed up on my google, suggesting that they do this kind of stuff really fluently.
And so I started, read Joe Armstrong book about Erlang, a few smaller books about OTP and Phoenix, and decided that I want a boilerplate, so that when a moment comes for me to use this in prod - I would have some idea.

One of the items I really want to have is authentication, both for human clients, and for APIs (for example if we have some frontend framework that will interact with API and require auth). There is a ton of material on how to setup authentication, but one thing I found it lacked was a single example of an app that uses both authentication for client and for API. Might sound obvious to do, but it took me a bit of time to figure it out, so I thought I might drop my boilerplate here, and explain how it came to be the way it is, and hopefully get some feedback on how to make it better.

## What will be implemented?
We will implement the following flows, using Phoenix and Guardian.
1) Login / Logout form, using Phoenix templates.
2) Login via API (an example that could be directly ported to some client app, e.g. React / Angular / Vue / whatever)
3) Login via magic link in the email, using Phoenix templates. (it is really easy to strap same thing on top of your client app, but I'll leave that out, or maybe add it once I have more time on my hands).

This repo is the ending state of the app.

### Getting started
First off, let's ensure we have things running correctly. This tutorial assumes you use Phoenix 1.3 version and have it setup with some Postgres db on the backend.
Then, create the application, and verify that it works:
```
mix phx.new multiauth
cd multiauth
mix deps.get && mix deps.compile
mix ecto.create
mix phx.server
```
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. We will see the expected default phoenix page, so all is good and we can proceed.

### Dependencies
Next, let's add the libs needed for setting up auth. Nothing special here, like in many other tutorials, we go with Guardian.
Pay attention to the versions, Guardian 1.0 has different callbacks!

Add guardian, comeoning and bcrypt_elixir to your project dependencies in <b>multiauth/mix.exs</b>:
```
defp deps do
  [
    {:phoenix, "~> 1.3.2"},
    {:phoenix_pubsub, "~> 1.0"},
    {:phoenix_ecto, "~> 3.2"},
    {:postgrex, ">= 0.0.0"},
    {:phoenix_html, "~> 2.10"},
    {:phoenix_live_reload, "~> 1.0", only: :dev},
    {:gettext, "~> 0.13.1"},
    {:cowboy, "~> 1.0"},
    {:guardian, "~> 1.0"},
    {:comeonin, "~> 4.0"},
    {:bcrypt_elixir, "~> 0.12"}
  ]
end
```

In <b>multiauth/config/config.ex</b>, let's add a Guardian specific config:
```
config :multiauth, Multiauth.Auth.Guardian,
  issuer: "Multiauth.#{Mix.env}",
  ttl: {60, :minutes},
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")
```
You can provide some secret key already here, if you don't want to set up any environment variables. As you see, we state here that the module with Guardian callbacks will be Multiauth.Auth.Guardian, and tokens will expire in 60 minutes. Now let's go implement that module.

### Guardian module
Our authentication will live in its own context. Phoenix 1.3 provides mix tasks to create boilerplate for the context.
```
mix phx.gen.context Auth User users email:string password:string username:string is_admin:boolean
mix ecto.migrate
```
You will see that a few files got created. Our Auth context will be responsible for all things auth, and will include the User schema, Guardian module implementing the callbacks, several methods that will help with handling passwords and also (closer to the end of the tutorial) the Mailer module that will be responsible for getting the magic links for you. Right now it only has the schema and methods to manipulate the records in that schema, but we will get all the good stuff implemented in a moment.

#### Guardian callbacks
Guardian expects several callbacks defined for it, and since here we use version 1.0, there is a bit of difference from how it is usually defined in tutorials.
[Callbacks](lib/multiauth/auth/guardian.ex)

#### Pipelines for router
These pipelines will be used to get the token from user requests and ensure user is authenticated.
[Pipeline](lib/multiauth/auth/pipeline.ex)

#### Login form
Disclaimer: we will not implement signup form here, let's just populate the database with a single user via the seed migration, and figure out signing up once we have some more time.

#### Migrations and seeds, using uuid for user id

#### Secret template to verify authorization works

#### Auth methods for authorizing the user

#### Routes

#### JS clientside example
Login request example:
```
fetch('http://localhost:4000/api/login', {
  body: JSON.stringify({username: "drapadubok", password: "admin"}),
  headers: {'content-type': 'application/json'},
  method: 'POST',
}).then(data => data.json()).then(data => localStorage.setItem('phoenixAuthToken', data.jwt))
```
Testing that we are authorized:
```
fetch('http://localhost:4000/api/json', {
  headers: {
    'content-type': 'application/json',
    'Authorization': 'Bearer ' + localStorage.getItem('phoenixAuthToken')
  }
}).then(data => data.json()).then(console.log)
```






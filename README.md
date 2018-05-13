# Multiauth: an etude on authentication in Phoenix (web framework in Elixir programming language).

It's been a few months that I started learning Elixir.
I started because I had one use case at work with Python, where I needed to parallelize a ton of IO operations, and I used a combination of multiprocessing and gevent to speed things up. It was quite a pain at first, and as I was reading on how to do this correctly, Erland and Elixir showed up on my google, suggesting that they do this kind of stuff really fluently.
And so I started, read Joe Armstrong book about Erlang, a few smaller books about OTP and Phoenix, and decided that I want a boilerplate, so that when a moment comes for me to use this in prod - I would have some idea.

One of the items I really want to have is authentication, both for human clients, and for APIs (for example if we have some frontend framework that will interact with API and require auth). There is a ton of material on how to setup authentication, but one thing I found it lacked was a single example of an app that uses both authentication for client and for API. Might sound obvious to do, but it took me a bit of time to figure it out, so I thought I might drop my boilerplate here, and explain how it came to be the way it is, and hopefully get some feedback on how to make it better.

### What will be implemented?
We will implement the following flows, using Phoenix and Guardian.
1) Login / Logout form, using Phoenix templates.
2) Login via API (an example that could be directly ported to some client app, e.g. React / Angular / Vue / whatever)
3) Login via magic link in the email, using Phoenix templates. (it is really easy to strap same thing on top of your client app, but I'll leave that out, or maybe add it once I have more time on my hands).

This repo is the ending state of the app.

#### Getting started
First off, let's ensure we have things running correctly. This tutorial assumes you use Phoenix 1.3 version and have it setup with some Postgres db on the backend.

First, we create the application, and verify that it works:
mix phx.new multiauth
cd multiauth
mix deps.get && mix deps.compile
mix ecto.create
mix phx.server

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. We will see the expected default phoenix page, so all is good and we can proceed.

##### Dependencies
Next, let's add the libs needed for setting up auth. Nothing special here, like in many other tutorials, we go with Guardian.
Add these to your project dependencies in multiauth/mix.exs. Pay attention to the versions, Guardian 1.0 has different callbacks!

{:guardian, "~> 1.0"},
{:comeonin, "~> 4.0"},
{:bcrypt_elixir, "~> 0.12"}

In multiauth/config/config.ex, let's add a Guardian specific config:

Now, in the config we will need to provide guardian specific info:

config :multiauth, Multiauth.Auth.Guardian,
  issuer: "Multiauth.#{Mix.env}",
  ttl: {60, :minutes},
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

You can provide some secret key already here, if you don't want to set up any environment variables. As you see, we state here that the module with Guardian callbacks will be Multiauth.Auth.Guardian, and tokens will expire in 60 minutes. Now let's go implement that module.

##### Guardian module
Our authentication will live in its own context. Phoenix 1.3 provides mix tasks to create boilerplate for the context.

mix phx.gen.context Auth User users email:string password:string username:string is_admin:boolean
mix ecto.migrate

You will see that a few files got created. Our Auth context will be responsible for all things auth, and will include the User schema, Guardian module implementing the callbacks, several methods that will help with handling passwords and also (closer to the end of the tutorial) the Mailer module that will be responsible for getting the magic links for you.




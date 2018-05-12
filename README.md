# Multiauth: an etude on authentication in Phoenix (web framework in Elixir programming language).

It's been a few months that I started learning Elixir.
I started because I had one use case at work with Python, where I needed to parallelize a ton of IO operations, and I used a combination of multiprocessing and gevent to speed things up. It was quite a pain at first, and as I was reading on how to do this correctly, Erland and Elixir showed up on my google, suggesting that they do this kind of stuff really fluently.
And so I started, read Joe Armstrong book about Erlang, a few smaller books about OTP and Phoenix, and decided that I want a boilerplate, so that when a moment comes for me to use this in prod - I would have some idea.

One of the items I really want to have is authentication, both for human clients, and for APIs (for example if we have some frontend framework that will interact with API and require auth). There is a ton of material on how to setup authentication, but one thing I found it lacked was a single example of an app that uses both authentication for client and for API. Might sound obvious to do, but it took me a bit of time to figure it out, so I thought I might drop my boilerplate here, and explain how it came to be the way it is, and hopefully get some feedback on how to make it better.

### What will be implemented?
We will implement the following flows, using Phoenix and Guardian.
1) Login / Logout form, using Phoenix templates.
2) Login via API (an example that could be directly ported to some client app, e.g. React / Angular / Vue / whatever)
3) Login via magic link in the email, using Phoenix templates.

#### Getting started
First off, let's ensure we have things running correctly. This tutorial assumes you use Phoenix 1.3 version and have it setup with some Postgres db on the backend.


First, we create the application, and verify that it works:
mix phx.new multiauth
cd multiauth
mix ecto.create
iex -S mix phx.server
We opened the link, got expected default phoenix page, so all is good and we can proceed.
... TODO
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

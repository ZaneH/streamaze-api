# Streamaze API

## Depends On

- [ZaneH/streamaze-donation-service](https://github.com/ZaneH/streamaze-donation-service)

## Setup

```
$ git clone https://github.com/ZaneH/streamaze-api.git
$ cd streamaze-api
$ mix deps.get
$ mix ecto.setup # check dev.exs if this fails
$ mix ecto.migrate
$ iex -S mix phx.server # on localhost:4000
```

## Environment Variables

```
# AWS config for S3 uploads
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=

# For OBS control, livebond is closed-source, fill this with a dummy value
export LIVEBOND_API_URL=

# For PayPal Subscriptions. Subscriptions aren't required in
# the open-source version, but the code is still there.
export PAYPAL_CLIENT_ID= # PayPal API client ID
export PAYPAL_SECRET_KEY= # PayPal API secret key
export PAYPAL_WEBHOOK_ID= # PayPal API webhook ID
export PAYPAL_PLAN_1_ID= # PayPal API plan ID

# Mailgun config
export MAILGUN_API_KEY=
export MAILGUN_DOMAIN=
```

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

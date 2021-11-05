import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app_ui, AppUiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SyXdamVb/I6t5fN6hGSZGstjfHH3Cpn/mJL5DnFy85gGa60AMQAbYsqyvJxV6c7h",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

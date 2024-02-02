import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dynamic_form, DynamicFormWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ZE8gIn4VMGc1VMSZu3ed6WloLFZV+Gb9UZvZ/EinyksdBFAyB9Wyjlve91FUVr65",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

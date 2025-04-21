require_relative "seeds/helpers"
raise "Seeding is just for development" unless Rails.env.development?

# Seed accounts
seed_account "37signals"
seed_account "honcho"
seed_account "first-run"

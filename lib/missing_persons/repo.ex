defmodule MissingPersons.Repo do
  use Ecto.Repo,
    otp_app: :missing_persons,
    adapter: Ecto.Adapters.Postgres
end

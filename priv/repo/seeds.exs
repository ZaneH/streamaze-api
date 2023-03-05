# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Streamaze.Repo.insert!(%Streamaze.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Streamaze.Repo

Repo.get_by(Streamaze.Accounts.Streamer, %{:youtube_url => "https://youtube.com/sam"}) ||
  Repo.insert!(%Streamaze.Accounts.Streamer{
    name: "Sam",
    youtube_url: "https://youtube.com/sam"
  })

Repo.get_by(Streamaze.Accounts.Streamer, %{:youtube_url => "https://youtube.com/@IcePoseidon"}) ||
  Repo.insert!(%Streamaze.Accounts.Streamer{
    name: "Ice Poseidon",
    youtube_url: "https://youtube.com/@IcePoseidon"
  })

Repo.get(Streamaze.Finances.Expense, 1) ||
  Repo.insert!(%Streamaze.Finances.Expense{
    value: Money.new(100_00, "USD"),
    amount_in_usd: 100.0,
    streamer_id: 1
  })

Repo.get(Streamaze.Finances.Expense, 2) ||
  Repo.insert!(%Streamaze.Finances.Expense{
    value: Money.new(-20_00, "USD"),
    amount_in_usd: -20.0,
    streamer_id: 1
  })

Repo.get(Streamaze.Finances.Donation, 1) ||
  Repo.insert!(%Streamaze.Finances.Donation{
    value: Money.new(500_00, "USD"),
    amount_in_usd: 500.0,
    sender: "John Doe",
    message: "Thanks for the stream!",
    type: "superchat",
    streamer_id: 1
  })

Repo.get(Streamaze.Finances.Donation, 2) ||
  Repo.insert!(%Streamaze.Finances.Donation{
    value: Money.new(100_00, "USD"),
    amount_in_usd: 100.0,
    sender: "Jane",
    type: "streamlabs_media",
    streamer_id: 1
  })

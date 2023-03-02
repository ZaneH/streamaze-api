defmodule Streamaze.StreamerManager do
  use Ecto.Schema

  schema "streamer_managers" do
    belongs_to :user, Streamaze.Accounts.User
    belongs_to :streamer, Streamaze.Accounts.Streamer

    timestamps()
  end

  @doc false
  def changeset(streamer_manager, _attrs) do
    streamer_manager
    |> Ecto.Changeset.cast_assoc(:user, required: true)
  end
end

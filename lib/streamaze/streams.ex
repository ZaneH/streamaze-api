defmodule Streamaze.Streams do
  @moduledoc """
  The Streams context.
  """

  import Ecto.Query, warn: false
  alias Streamaze.Repo

  alias Streamaze.Accounts.Streamer

  @doc """
  Returns the list of streamers.

  ## Examples

      iex> list_streamers()
      [%Streamer{}, ...]

  """
  def list_streamers do
    Repo.all(Streamer)
  end

  @doc """
  Gets a single streamer.

  Raises `Ecto.NoResultsError` if the Streamer does not exist.

  ## Examples

      iex> get_streamer!(123)
      %Streamer{}

      iex> get_streamer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_streamer!(id), do: Repo.get!(Streamer, id)

  @doc """
  Creates a streamer.

  ## Examples

      iex> create_streamer(%{field: value})
      {:ok, %Streamer{}}

      iex> create_streamer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_streamer(attrs \\ %{}) do
    %Streamer{}
    |> Streamer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a streamer.

  ## Examples

      iex> update_streamer(streamer, %{field: new_value})
      {:ok, %Streamer{}}

      iex> update_streamer(streamer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_streamer(%Streamer{} = streamer, attrs) do
    streamer
    |> Streamer.changeset(attrs)
    |> Repo.update()
  end

  def get_streamers_net_profit(streamer_id) do
    streamer = get_streamer!(streamer_id)

    expenses = Ecto.assoc(streamer, :expenses) |> Repo.all()
    donations = Ecto.assoc(streamer, :donations) |> Repo.all()

    net_profit =
      Enum.reduce(donations, 0, fn donation, acc ->
        acc + donation.amount
      end) +
        Enum.reduce(expenses, 0, fn expense, acc ->
          acc + expense.amount
        end)

    net_profit / 1
  end

  @doc """
  Deletes a streamer.

  ## Examples

      iex> delete_streamer(streamer)
      {:ok, %Streamer{}}

      iex> delete_streamer(streamer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_streamer(%Streamer{} = streamer) do
    Repo.delete(streamer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking streamer changes.

  ## Examples

      iex> change_streamer(streamer)
      %Ecto.Changeset{data: %Streamer{}}

  """
  def change_streamer(%Streamer{} = streamer, attrs \\ %{}) do
    Streamer.changeset(streamer, attrs)
  end

  alias Streamaze.Streams.LiveStream

  @doc """
  Returns the list of live_streams.

  ## Examples

      iex> list_live_streams()
      [%LiveStream{}, ...]

  """
  def list_live_streams do
    LiveStream |> Ecto.Query.preload(:streamer) |> Repo.all()
  end

  def list_active_live_streams(streamer_id) do
    Repo.all(from l in LiveStream, where: l.is_live == true and l.streamer_id == ^streamer_id)
  end

  def list_inactive_live_streams(streamer_id) do
    Repo.all(from l in LiveStream, where: l.is_live == false and l.streamer_id == ^streamer_id)
  end

  def list_active_subathons(streamer_id) do
    Repo.all(
      from l in LiveStream,
        where: l.is_live == true and l.streamer_id == ^streamer_id and l.is_subathon == true
    )
  end

  @doc """
  Gets a single live_stream.

  Raises `Ecto.NoResultsError` if the Live stream does not exist.

  ## Examples

      iex> get_live_stream!(123)
      %LiveStream{}

      iex> get_live_stream!(456)
      ** (Ecto.NoResultsError)

  """
  def get_live_stream!(id), do: Repo.get!(LiveStream, id)

  @doc """
  Creates a live_stream.

  ## Examples

      iex> create_live_stream(%{field: value})
      {:ok, %LiveStream{}}

      iex> create_live_stream(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_live_stream(attrs \\ %{}) do
    %LiveStream{}
    |> LiveStream.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a live_stream.

  ## Examples

      iex> update_live_stream(live_stream, %{field: new_value})
      {:ok, %LiveStream{}}

      iex> update_live_stream(live_stream, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_live_stream(%LiveStream{} = live_stream, attrs) do
    live_stream
    |> LiveStream.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a live_stream.

  ## Examples

      iex> delete_live_stream(live_stream)
      {:ok, %LiveStream{}}

      iex> delete_live_stream(live_stream)
      {:error, %Ecto.Changeset{}}

  """
  def delete_live_stream(%LiveStream{} = live_stream) do
    Repo.delete(live_stream)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking live_stream changes.

  ## Examples

      iex> change_live_stream(live_stream)
      %Ecto.Changeset{data: %LiveStream{}}

  """
  def change_live_stream(%LiveStream{} = live_stream, attrs \\ %{}) do
    LiveStream.changeset(live_stream, attrs)
  end
end

defmodule Streamaze.Finances do
  @moduledoc """
  The Finances context.
  """

  import Ecto.Query, warn: false
  alias Streamaze.Repo

  alias Streamaze.Finances.{Expense, Donation}

  def list_streamer_expenses(_streamer_id = nil) do
    []
  end

  def list_streamer_expenses(streamer_id, limit \\ 10) do
    Expense
    |> where([e], e.streamer_id == ^streamer_id)
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id), do: Repo.get!(Expense, id)

  def get_streamers_total_expenses(streamer_id) do
    Expense
    |> where([e], e.streamer_id == ^streamer_id)
    |> select([e], sum(e.amount_in_usd))
    |> Repo.one()
  end

  def get_all_sub_count(streamer_id) do
    Donation
    |> where(
      [e],
      e.streamer_id == ^streamer_id and
        e.months > 0
    )
    |> select([e], sum(e.months))
    |> Repo.one()
  end

  def get_kick_sub_count(streamer_id) do
    Donation
    |> where(
      [e],
      e.streamer_id == ^streamer_id and
        (e.type == "kick_subscription" or e.type == "kick_gifted_subscription")
    )
    |> select([e], sum(e.months))
    |> Repo.one()
  end

  def get_youtube_sub_count(streamer_id) do
    Donation
    |> where(
      [e],
      e.streamer_id == ^streamer_id and
        e.type == "subscription"
    )
    |> select([e], sum(e.months))
    |> Repo.one()
  end

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end

  alias Streamaze.Finances.Donation

  def paginate_donations(
        streamer_id,
        cursors \\ %{
          before: nil,
          after: nil
        }
      ) do
    query =
      from(d in Donation,
        where: d.streamer_id == ^streamer_id,
        order_by: [desc: d.inserted_at, desc: d.id]
      )

    Repo.paginate(query,
      limit: 15,
      include_total_count: true,
      cursor_fields: [:inserted_at, :id],
      after: cursors.after,
      before: cursors.before,
      sort_direction: :desc
    )
  end

  def list_streamer_donations(_streamer_id = nil) do
    []
  end

  def list_streamer_donations(streamer_id, limit \\ 10) do
    Donation
    |> where([d], d.streamer_id == ^streamer_id)
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Gets a single donation.

  Raises `Ecto.NoResultsError` if the Donation does not exist.

  ## Examples

      iex> get_donation!(123)
      %Donation{}

      iex> get_donation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_donation!(id), do: Repo.get!(Donation, id)

  def get_streamers_total_donations(streamer_id) do
    Donation
    |> where([d], d.streamer_id == ^streamer_id)
    |> select([d], sum(d.amount_in_usd))
    |> Repo.one()
  end

  @doc """
  Creates a donation.

  ## Examples

      iex> create_donation(%{field: value})
      {:ok, %Donation{}}

      iex> create_donation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_donation(attrs \\ %{}) do
    %Donation{}
    |> Donation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a donation.

  ## Examples

      iex> update_donation(donation, %{field: new_value})
      {:ok, %Donation{}}

      iex> update_donation(donation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_donation(%Donation{} = donation, attrs) do
    donation
    |> Donation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a donation.

  ## Examples

      iex> delete_donation(donation)
      {:ok, %Donation{}}

      iex> delete_donation(donation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_donation(%Donation{} = donation) do
    Repo.delete(donation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking donation changes.

  ## Examples

      iex> change_donation(donation)
      %Ecto.Changeset{data: %Donation{}}

  """
  def change_donation(%Donation{} = donation, attrs \\ %{}) do
    Donation.changeset(donation, attrs)
  end
end

# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Finances do
  @moduledoc """
  The Finances context.
  """

  import Ecto.Query, warn: false
  alias Streamaze.Payments.PaypalEvent
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

  def pagination_expenses(
        streamer_id,
        cursors \\ %{
          before: nil,
          after: nil
        }
      ) do
    query =
      from(e in Expense,
        where: e.streamer_id == ^streamer_id,
        order_by: [desc: e.inserted_at, desc: e.id]
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
    query =
      from(d in Donation,
        where:
          d.streamer_id == ^streamer_id and
            d.exclude_from_profit != true,
        select: sum(d.amount_in_usd)
      )

    Repo.one(query)
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

  defp get_subscription_status(user_id) do
    Cachex.get(:subscription_cache, Kernel.to_string(user_id))
  end

  defp store_subscription_status(user_id, status) do
    Cachex.put(:subscription_cache, Kernel.to_string(user_id), status)
  end

  defp check_subscription(user_id) do
    true

    # uncomment to check for valid PayPal subscription
    #
    # paypal_events =
    #   PaypalEvent
    #   |> where([ps], ps.user_id == ^user_id)
    #   |> where(
    #     [ps],
    #     ps.event_type == "BILLING.SUBSCRIPTION.ACTIVATED"
    #   )
    #   |> order_by(desc: :inserted_at)
    #   |> limit(1)
    #   |> Repo.one()

    # result =
    #   case paypal_events do
    #     nil ->
    #       IO.puts("No subscription found for user_id: #{user_id}")
    #       false

    #     _ ->
    #       IO.puts("Valid subscription found for user_id: #{user_id}")
    #       inserted_at = paypal_events.inserted_at |> DateTime.from_naive!("Etc/UTC")
    #       now = DateTime.utc_now()
    #       diff = DateTime.diff(now, inserted_at, :day)

    #       diff < 31
    #   end

    # # Store the result in the cache
    # store_subscription_status(user_id, result)

    # result
  end

  def has_valid_subscription?(user_id) when is_nil(user_id) do
    false
  end

  def has_valid_subscription?(user_id) do
    case get_subscription_status(user_id) do
      {:ok, true} ->
        true

      _ ->
        # Handle no subscription or cache error
        # fallback to rechecking the subscription
        case check_subscription(user_id) do
          true ->
            true

          _ ->
            false
        end
    end
  end
end

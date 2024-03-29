# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.DonationView do
  use StreamazeWeb, :view

  def render("index.json", %{donations: donations}) do
    %{data: render_many(donations, StreamazeWeb.DonationView, "show.json")}
  end

  def render("create.json", %{donation: donation}) do
    %{success: true, data: render_one(donation, StreamazeWeb.DonationView, "show.json")}
  end

  def render("show.json", %{donation: donation}) do
    %{
      id: donation.id,
      value: %{
        amount: donation.value.amount,
        currency: donation.value.currency
      },
      amount_in_usd: donation.amount_in_usd,
      sender: donation.sender,
      type: donation.type,
      message: donation.message,
      metadata: donation.metadata,
      created_at: donation.inserted_at,
      updated_at: donation.updated_at,
      streamer_id: donation.streamer_id
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{
      success: false,
      errors:
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
            opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
          end)
        end)
    }
  end
end

# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.streamer_index_path(@socket, :index)}>
        <.live_component
          module={StreamazeWeb.StreamerLive.FormComponent}
          id={@streamer.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.streamer_index_path(@socket, :index)}
          streamer: @streamer
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def donation_type_to_string(donation_type) do
    case donation_type do
      "kick_host" -> "Kick Host"
      "kick_gifted_subscription" -> "Kick Gifted Subscription"
      "kick_subscription" -> "Kick Subscription"
      "superchat" -> "Superchat"
      "tiktok_gift" -> "Tiktok Gift"
      "subscription" -> "YouTube Subscription"
      "streamlabs_media" -> "Streamlabs Media"
      "donation" -> "Streamlabs Donation"
      _ -> donation_type
    end
  end

  def replace_empty_string_with_nil(value) when value === "", do: nil
  def replace_empty_string_with_nil(value), do: value
end

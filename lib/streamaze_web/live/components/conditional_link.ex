# Copyright 2023, Zane Helton, All rights reserved.

defmodule ConditionalLink do
  use Phoenix.Component
  import Phoenix.HTML.Link

  def render(assigns) do
    ~H"""
    <%= if @condition do %>
      <%= link to: @to do %>
        <%= render_slot(@inner_block) %>
      <% end %>
    <% else %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end
end

# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.PageController do
  use StreamazeWeb, :controller

  alias Streamaze.Streams

  def index(conn, _params) do
    live_list = Streams.list_live_streams() |> Enum.uniq_by(& &1.streamer_id)
    render(conn, "index.html", live_list: live_list)
  end
end

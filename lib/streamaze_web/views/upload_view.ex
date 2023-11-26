# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.UploadView do
  use StreamazeWeb, :view

  def render("success.json", %{success: success}) do
    %{success: success}
  end

  def error("error.json", %{error: error}) do
    %{success: false, error: error}
  end
end

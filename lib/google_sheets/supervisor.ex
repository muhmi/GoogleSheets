
defmodule GoogleSheets.Supervisor do

  @moduledoc """
  Supervisor for the application. Creates ETS table for storage and launches a process for each spreadsheet configured for polling.
  """

  use Supervisor
  require Keyword

  @doc false
  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: __MODULE__])
  end

  @doc false
  def init([]) do
    # ETS table is created here, so that if the updater process dies, the table is not lost.
    # Must set the permission to public, so that the GoogleSheets.Updater can write
    # to the table, even if it's not the owning process.
    :ets.new :google_sheets, [:set, :named_table, :public]

    spreadsheets = Application.get_env :google_sheets, :spreadsheets, []
    supervise create_children(spreadsheets, []), strategy: :one_for_one
  end

  # Create a children for each configured spreadsheet
  defp create_children([], children), do: children
  defp create_children([spreadsheet | rest], children) do
    id = Keyword.fetch! spreadsheet, :id
    create_children rest, [worker(GoogleSheets.Updater, [spreadsheet], [id: id, restart: :permanent]) | children]
  end

end
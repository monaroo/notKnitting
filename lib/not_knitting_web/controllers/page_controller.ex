defmodule NotKnittingWeb.PageController do
  use NotKnittingWeb, :controller
  alias NotKnitting.Patterns

  def home(conn, _params) do
    patterns = Patterns.list_patterns(limit: 8)
    render(conn, :home, layout: false, patterns: patterns)
  end
end

defmodule Test1.AuthentificationHelper do

  import Plug.Conn
  import Test1Web.Router.Helpers

  @doc """
  Checks if user is authentified. Redirects to sign in page if not.
  """
  @spec authenticate_user(Plug.Conn.t, any) :: Plug.Conn.t
  def authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
	conn
	|> Phoenix.Controller.put_flash(:error, "Login required")
	|> Phoenix.Controller.redirect(to: session_path(conn, :new))
	|> halt()
      user_id ->
	conn
	|> assign(:current_user, Test1.Accounts.get_user!(user_id))
    end
  end
end

defmodule Cal.HTTPoison do
  @moduledoc """
  Module meant that uses `HTTPoison` on production envs
  and mocks behaviour when testing.
  """

  @httpoison (Application.compile_env(:elixir_auth_google, :httpoison_mock) && Cal.HTTPoisonMock) || HTTPoison

  @type conn :: map

  @doc """
  `inject_poison/0` injects a TestDouble of HTTPoison in Test
  so that we don't have duplicate mock in consuming apps.
  see: https://github.com/dwyl/elixir-auth-google/issues/35
  """
  def httpoison, do: @httpoison
end

defmodule Cal.HTTPoisonMock do
  @moduledoc """
  This is a TestDouble for HTTPoison which returns a predictable response.
  Please see: https://github.com/dwyl/elixir-auth-google/issues/35
  """

  @doc """
  get/1 for the calendar. Will return a calendar object with random data.
  See https://developers.google.com/calendar/api/v3/reference/calendars.
  Obviously, don't invoke it from your App unless you want people to see fails.
  """
  def get("https://www.googleapis.com/calendar/v3/calendars/primary", _headers) do
    body = Jason.encode!(%{id: "someid"})
    {:ok, %{ body: body}}
  end

  # get/1 that is used to mock fetching event lists.
  def get(_url, _headers, params: _params) do
    body = Jason.encode!(
      %{ items: [ %{
            "created" => "2022-03-22T12:34:08.000Z",
            "creator" => %{"email" => "someemail@email.com", "self" => true},
            "end" => %{"date" => "2023-04-22"},
            "id" => "cphjep9g6dgj2b9g6kpj2b9k6hijgb9oc8pj0bb66kqj4db16op38db36s_20230421",
            "organizer" => %{"email" => "someemail@email.com", "self" => true},
            "originalStartTime" => %{"date" => "2023-04-21"},
            "start" => %{"date" => "2023-04-21"},
            "status" => "confirmed",
            "summary" => "Some title",
          },
          %{
            "created" => "2022-03-23T12:34:08.000Z",
            "creator" => %{"email" => "someemail@email.com", "self" => true},
            "end" => %{
              "dateTime" => "2023-03-20T02:00:00Z",
              "timeZone" => "Europe/Lisbon"
            },
            "id" => "cphjep9g6dgjasdasdghsa1234gsa4db16op38db36asd1sdfas1",
            "organizer" => %{"email" => "someemail@email.com", "self" => true},
            "originalStartTime" => %{"date" => "2023-04-21"},
            "start" => %{
              "dateTime" => "2023-03-20T01:00:00Z",
              "timeZone" => "Europe/Lisbon"
            },
            "status" => "confirmed",
            "summary" => "Some title",
          }]}
    )

    {:ok, %{ body: body }}
  end


  @doc """
  post/2 will just return a mocked success.
  """
  def post(_url, _body, _headers) do
    {:ok, %{body: Jason.encode!(%{})}}
  end
end

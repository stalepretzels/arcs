defmodule ArcsWeb.RoomChannelTest do
  use ArcsWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      ArcsWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(ArcsWeb.RoomChannel, "room:lobby")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to room:lobby a message with username", %{socket: socket} do
    push(socket, "shout", %{"name" => "test_username", "message" => "hey all"})
    assert_broadcast "shout", %{"name" => "test_username", "message" => "hey all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end

  test ":after_join sends all existing messages", %{socket: socket} do
    # insert a new message to send in the :after_join
    payload = %{name: "Alex", message: "test"}
    Arcs.Message.changeset(%Arcs.Message{}, payload) |> Arcs.Repo.insert()

    {:ok, _, socket2} =
      ArcsWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(ArcsWeb.RoomChannel, "room:lobby")

    assert socket2.join_ref != socket.join_ref
  end
end

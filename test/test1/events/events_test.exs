defmodule Test1.EventsTest do
  use Test1.DataCase

  alias Test1.Events

  describe "events" do
    alias Test1.Events.Event

    @valid_attrs %{address: "some address", city: "some city", cover: "some cover", date: ~N[2010-04-17 14:00:00], description: "some description", link: "some link", title: "some title"}
    @update_attrs %{address: "some updated address", city: "some updated city", cover: "some updated cover", date: ~N[2011-05-18 15:01:01], description: "some updated description", link: "some updated link", title: "some updated title"}
    @invalid_attrs %{address: nil, city: nil, cover: nil, date: nil, description: nil, link: nil, title: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.address == "some address"
      assert event.city == "some city"
      assert event.cover == "some cover"
      assert event.date == ~N[2010-04-17 14:00:00]
      assert event.description == "some description"
      assert event.link == "some link"
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.address == "some updated address"
      assert event.city == "some updated city"
      assert event.cover == "some updated cover"
      assert event.date == ~N[2011-05-18 15:01:01]
      assert event.description == "some updated description"
      assert event.link == "some updated link"
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end

defmodule Pnum do
    @moduledoc """
    Concurrent collection enumeration

    Wraps the stdlib `Enum` module which implements the `Enumerable` protocol.
    Implementation and documentation should mimic the `Enum` module.
    """

    @type t :: Enumerable.t
    @type item :: any

    @doc """
    Returns a new collection, where each item is the result of invoking `func`
    on each corresponding item of `collection`.

    For dicts, the function expects a key-value tuple.

    ## Examples

        iex> Pnum.map([1, 2, 3], fn(x) -> x * 2 end)
        [2, 4, 6]

        iex> Pnum.map([a: 1, b: 2], fn({k, v}) -> { k, -v } end)
        [a: -1, b: -2]

    """
    @spec map(t, (item -> any)) :: list
    def map(collection, func) do
        process_many(collection, func) |> collect
    end

    @doc """
    Sends the result of invoking `func` with `item` to the parent PID in a
    `{child_pid, result}` tuple. Returns the resulting tuple.

    Used internally to facilitate `Pnum` concurrent operations.

    ## Examples

        iex> Pnum.process(1, fn(x) -> x * 2 end, self)
        {#PID<0.42.0>, 2}

    """
    @spec process(item, (item -> any), pid) :: any
    def process(item, func, parent) do
        send(parent, {self, func.(item)})
    end

    # Collect process results into a new list
    defp collect(pids) do
        Enum.map pids, &receive do: ({^&1, result} -> result)
    end

    # Spawn a process for every item in the collection and apply `func`
    defp process_many(collection, func) do
        Enum.map collection, &spawn_link(__MODULE__, :process, [&1, func, self])
    end
end

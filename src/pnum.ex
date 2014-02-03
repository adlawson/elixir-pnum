defmodule Pnum do
    @moduledoc """
    Concurrent collection enumeration

    Wraps the stdlib `Enum` module which implements the `Enumerable` protocol.
    Implementation and documentation should mimic the `Enum` module.
    """

    @type t :: Enumerable.t
    @type item :: any

    @doc """
    Filters the collection, i.e. returns only those items for which `func`
    returns `true`.

    ## Examples

        iex> Pnum.filter([1, 2, 3], fn(x) -> rem(x, 2) == 0 end)
        [2]

    """
    @spec filter(t, (item -> as_boolean(term))) :: list
    def filter(collection, func) do
        process_many(collection, &({func.(&1), &1}))
        |> collect
        |> filter_results
    end

    @doc """
    Filter the collection and map values in one pass.

    ## Examples

        iex> Pnum.filter_map([1, 2, 3], fn(x) -> rem(x, 2) == 0 end, &(&1 * 2))
        [4]

    """
    @spec filter_map(t, (item -> as_boolean(term)), (item -> item)) :: list
    def filter_map(collection, filter, mapper) do
        process_many(collection, &({filter.(&1), mapper.(&1)}))
        |> collect
        |> filter_results
    end

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

    # Filter based on item(0) of each tuple
    defp filter_results([]), do: []
    defp filter_results([head|tail]) do
        case head do
            {true, value} -> [value] ++ filter_results(tail)
            {false, _val} -> filter_results(tail)
        end
    end

    # Spawn a process for every item in the collection and apply `func`
    defp process_many(collection, func) do
        Enum.map collection, &spawn_link(__MODULE__, :process, [&1, func, self])
    end
end

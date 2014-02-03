defmodule PnumTest.List do
    use ExUnit.Case, async: true

    test :map do
        assert Pnum.map([], &(&1 * 2)) === []
        assert Pnum.map([1, 2, 3], &(&1 * 2)) === [2, 4, 6]
    end
end

defmodule PnumTest.Range do
    use ExUnit.Case, async: true

    test :map do
        assert Pnum.map(1..3, &(&1 * 2)) === [2, 4, 6]
        assert Pnum.map(-1..-3, &(&1 * 2)) === [-2, -4, -6]
    end
end

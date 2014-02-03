defmodule PnumTest.List do
    use ExUnit.Case, async: true

    test :filter do
        assert Pnum.filter([1, 2, 3], &(rem(&1, 2) === 0)) === [2]
        assert Pnum.filter([2, 4, 6], &(rem(&1, 2) === 0)) === [2, 4, 6]
    end

    test :filter_map do
        assert Pnum.filter_map([1, 2, 3], &(rem(&1, 2) === 0), &(&1 * 2)) === [4]
        assert Pnum.filter_map([2, 4, 6], &(rem(&1, 2) === 0), &(&1 * 2)) === [4, 8, 12]
    end

    test :map do
        assert Pnum.map([], &(&1 * 2)) === []
        assert Pnum.map([1, 2, 3], &(&1 * 2)) === [2, 4, 6]
    end
end

defmodule PnumTest.Range do
    use ExUnit.Case, async: true

    test :filter do
        assert Pnum.filter(1..3, &(rem(&1, 2) === 0)) === [2]
        assert Pnum.filter(1..6, &(rem(&1, 2) === 0)) === [2, 4, 6]
    end

    test :filter_map do
        assert Pnum.filter_map(1..3, &(rem(&1, 2) === 0), &(&1 * 2)) === [4]
        assert Pnum.filter_map(2..6, &(rem(&1, 2) === 0), &(&1 * 2)) === [4, 8, 12]
    end

    test :map do
        assert Pnum.map(1..3, &(&1 * 2)) === [2, 4, 6]
        assert Pnum.map(-1..-3, &(&1 * 2)) === [-2, -4, -6]
    end
end

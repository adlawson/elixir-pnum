# Pnum.ex

<img src="http://stream1.gifsoup.com/view3/1126685/kid-shows-how-to-parallel-park-o.gif" width="240px" align="right"/>

**Version:** `1.0.0-dev` `Unstable`<br/>
**Master build:** [![Master branch build status][travis-master]][travis]<br/>
**Requires:** `Elixir >= 0.12.2`

**Pnum** is a simple module for simple concurrent enumeration.
When using this library you should note that concurrent list enumeration is not
necessarily the fastest or most efficient method, but in some cases it can
offer the perfect solution.

It can be installed in whichever way you prefer, but I recommend standard Mixfile project dependencies.
```elixir
defmodule MyProject.Mixfile do
    #...

    defp deps do
      [{:pnum, github: "adlawson/pnum.ex", tag: "1.0.0-dev" }]
    end
end
```

### Usage
 - <h4>filter(collection, func)</h4>
 **`@spec filter(t, (item -> as_boolean(term))) :: list`**

 Filters the collection, i.e. returns only those items for which `func`
 returns `true`.

 ```bash
iex> Pnum.filter([1, 2, 3], fn(x) -> rem(x, 2) == 0 end)
[2]
 ```


 - <h4>filter_map(collection, filter, mapper)</h4>
 **`@spec filter_map(t, (item -> as_boolean(term)), (item -> item)) :: list`**

 Filter the collection and map values in one pass.

 ```bash
iex> Pnum.filter_map([1, 2, 3], fn(x) -> rem(x, 2) == 0 end, &(&1 * 2))
[4]
 ```


 - <h4>map(collection, func)</h4>
**`@spec map(t, (item -> any)) :: list`**

 Returns a new collection, where each item is the result of invoking `func`
 on each corresponding item of `collection`.

 For dicts, the function expects a key-value tuple.

 ```bash
iex> Pnum.map([1, 2, 3], fn(x) -> x * 2 end)
[2, 4, 6]
iex> Pnum.map([a: 1, b: 2], fn({k, v}) -> { k, -v } end)
[a: -1, b: -2]
 ```


 - <h4>process(item, func, parent)</h4>
 **`@spec process(item, (item -> any), pid) :: any`**

 Sends the result of invoking `func` with `item` to the parent PID in a
 `{child_pid, result}` tuple. Returns the resulting tuple.

 Used internally to facilitate `Pnum` concurrent operations.

 ```bash
iex> Pnum.process(1, fn(x) -> x * 2 end, self)
{#PID<0.42.0>, 2}
 ```


### Contributing
Contributions are accepted via Pull Request,
but passing unit tests must be included before it will be considered for merge.
```bash
$ mix test
```

A basic Vagrant development VM is available at [adlawson/vagrantfiles][vagrantfile] for easy setup.
```bash
$ curl -O https://raw.github.com/adlawson/vagrantfiles/master/elixir/Vagrantfile
$ vagrant up
$ vagrant ssh
...
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)
$ cd /srv
```


### License
The content of this library is released under the **MIT License** by **Andrew Lawson**.<br/>
You can find a copy of this license in [`LICENSE`][license] or at http://opensource.org/licenses/mit.

<!-- URLs -->
[travis]: https://travis-ci.org/adlawson/pnum.ex
[travis-master]: https://api.travis-ci.org/adlawson/pnum.ex.png?branch=master
[vagrantfile]: https://github.com/adlawson/vagrantfiles
[license]: /LICENSE

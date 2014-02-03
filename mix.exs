defmodule Pnum.Mixfile do
    use Mix.Project

    def project do
        [app: :pnum,
         version: "1.0.0-dev",
         elixir: "~> 0.12.2",
         elixirc_paths: ["src"],
         erlc_paths: []]
    end
end

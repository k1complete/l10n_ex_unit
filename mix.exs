defmodule L10nExUnit.Mixfile do
  use Mix.Project

  def project do
    [app: :l10n_ex_unit,
     version: "0.0.1",
     elixir: "~> 1.0",
     compilers: Mix.compilers ++ [:po],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :exgettext, :ex_unit]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
     {:exgettext, git: "https://github.com/k1complete/exgettext.git"}
#     {:exgettext, path: "../"}
    ]
  end
end

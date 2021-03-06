defmodule L10nExUnit.Mixfile do
  use Mix.Project

  def project do
    [app: :l10n_ex_unit,
     version: "0.0.4",
#     elixir: "~> 1.1.0-beta",
     compilers: Mix.compilers ++ [:po],
     source_url: "https://github.com/elixir-lang/elixir",
     homepage_url: "https://elixir-lang/docs",
     docs: docs,
     deps: deps]
  end
  def abs_path(s) when is_list(s) do
    Path.join([File.cwd! | s])
  end
  def abs_path(s) do
    Path.join(File.cwd!, s)
  end
  def make_source_ref(source_dir) do
    gitdir = Path.join(source_dir, ".git")
    {shead, 0} = System.cmd("git", ["--git-dir", gitdir, 
                                    "rev-parse", "HEAD"])
    shead = String.rstrip(shead)
    {stag, 0} = System.cmd("git", ["--git-dir", gitdir, 
                                   "tag", "--points-at", shead])
    stag = String.rstrip(stag)
    case stag do
      nil -> shead
      "" -> shead
      _ -> stag
    end
  end
  def docs do 
    source_dir = "deps/elixir"
    sr = abs_path([source_dir, "lib/ex_unit/ebin"])
#    IO.inspect File.ls(source_dir)
    sref = if (File.exists?(source_dir)) do
             make_source_ref(source_dir)
           else
             nil
           end
    version_path = Path.join(source_dir, "VERSION")
#    IO.inspect [version_path: version_path, sref: sref]
    {:ok, version} = if File.exists?(version_path) do
                       File.read(version_path)
                     else
                       {:ok, nil}
                     end
    [
     project: "ExUnit",
     app: "ex_unit",
     version: version,
     formatter: Exgettext.HTML,
     source_root: abs_path("deps/elixir"),
     logo: "logo.png",
     logo_url: "priv/logo.png",
     source_beam: sr,
     source_ref: sref,
     output: "doc/ex_unit",
     main: "ExUnit"
    ]
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
    [{:elixir, github: "elixir-lang/elixir"}, # tag: "v1.1.0" },
     {:ex_doc, github: "elixir-lang/ex_doc"},
     {:earmark, "~> 0.1.17 or ~> 0.2", optional: true},
     {:exgettext, github: "k1complete/exgettext"}
#     {:exgettext, path: "../"}
    ]
  end
end

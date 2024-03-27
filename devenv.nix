{ pkgs, ... }:

{
  packages = with pkgs; [
    exercism
    nil
    nixpkgs-fmt
    rebar3
  ];

  languages = {
    erlang.enable = true;
    gleam.enable = true;
    nix.enable = true;
  };
}

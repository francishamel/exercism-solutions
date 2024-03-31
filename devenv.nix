{ pkgs, ... }:

{
  packages = [
    pkgs.bats
    pkgs.exercism
    pkgs.nil
    pkgs.nixpkgs-fmt
    pkgs.jq
    pkgs.rebar3
  ];

  languages = {
    erlang.enable = true;
    gleam.enable = true;
    nix.enable = true;
  };
}

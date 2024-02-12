flake: let
  collectFlakeInputs = input:
    [input]
    ++ builtins.concatMap collectFlakeInputs (
      builtins.attrValues (
        input.inputs or {}
      )
    );
in
  collectFlakeInputs flake

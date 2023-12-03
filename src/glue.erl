-module(glue).

-export([match/2]).

match(S, P) ->
    case re:run(S, P, [global, {capture, all_names}]) of
        {match, Matches} -> Matches
    end.

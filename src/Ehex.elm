module Ehex exposing (fromInt)

import Dict


ehex : Dict.Dict Int String
ehex =
    let
        letters =
            List.filter (\letter -> not (List.member letter [ 'I', 'O' ])) <| List.map Char.fromCode (List.range 65 90)

        values =
            List.append (List.map String.fromInt (List.range 0 9)) (List.map String.fromChar letters)
    in
    Dict.fromList (List.map2 Tuple.pair (List.range 0 33) values)


fromInt : Int -> String
fromInt int =
    case Dict.get int ehex of
        Just value ->
            value

        Nothing ->
            "?"

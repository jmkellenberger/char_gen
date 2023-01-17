module Career exposing (Career(..), fromString, listCareers, toString)


type Career
    = Navy
    | Marines
    | Army
    | Scouts
    | Merchants
    | Other


toString : Career -> String
toString c =
    case c of
        Navy ->
            "Navy"

        Marines ->
            "Marines"

        Army ->
            "Army"

        Scouts ->
            "Scouts"

        Merchants ->
            "Merchants"

        Other ->
            "Other"


fromString : String -> Career
fromString c =
    case c of
        "Navy" ->
            Navy

        "Marines" ->
            Marines

        "Army" ->
            Army

        "Scouts" ->
            Scouts

        "Merchants" ->
            Merchants

        _ ->
            Other


listCareers : List Career
listCareers =
    [ Scouts, Other ]

module Main exposing (main)

import Browser
import Ehex
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Random exposing (Generator)
import Random.Extra as Random



-- MODEL


type alias Stats =
    { str : Int
    , dex : Int
    , end : Int
    , int : Int
    , edu : Int
    , soc : Int
    }


twoDice : Generator Int
twoDice =
    Random.map2 (+) (Random.int 1 6) (Random.int 1 6)


randomStats : Generator Stats
randomStats =
    Random.map Stats twoDice
        |> Random.andMap twoDice
        |> Random.andMap twoDice
        |> Random.andMap twoDice
        |> Random.andMap twoDice
        |> Random.andMap twoDice


rollStats : Cmd Msg
rollStats =
    Random.generate StatsRolled randomStats


type alias Model =
    { stats : Stats }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { stats = Stats 6 6 6 6 6 6 }, Cmd.none )



-- UPDATE


type Msg
    = RerollClicked
    | StatsRolled Stats


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RerollClicked ->
            ( model, rollStats )

        StatsRolled stats ->
            ( { model | stats = stats }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ viewPlayerCard model
        , viewStats model.stats
        ]


viewStats : Stats -> Html Msg
viewStats stats =
    Html.div []
        [ Html.ul []
            [ Html.li [] [ Html.text ("Strength: " ++ String.fromInt stats.str) ]
            , Html.li [] [ Html.text ("Dexterity: " ++ String.fromInt stats.dex) ]
            , Html.li [] [ Html.text ("Endurance: " ++ String.fromInt stats.end) ]
            , Html.li [] [ Html.text ("Intelligence: " ++ String.fromInt stats.int) ]
            , Html.li [] [ Html.text ("Education: " ++ String.fromInt stats.edu) ]
            , Html.li [] [ Html.text ("Social Standing: " ++ String.fromInt stats.soc) ]
            ]
        , Html.button [ Html.Events.onClick RerollClicked ] [ Html.text "Reroll Stats" ]
        ]


viewUPP : Stats -> String
viewUPP stats =
    Ehex.fromInt stats.str
        ++ Ehex.fromInt stats.dex
        ++ Ehex.fromInt stats.end
        ++ Ehex.fromInt stats.int
        ++ Ehex.fromInt stats.edu
        ++ Ehex.fromInt stats.soc


viewPlayerCard : Model -> Html Msg
viewPlayerCard model =
    Html.div [ Html.Attributes.id "player-card" ] [ Html.text ("UPP: " ++ viewUPP model.stats) ]



-- MAIN


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = always Sub.none }

module Main exposing (Model, Msg, Stats, Step, main)

import Browser
import Career exposing (Career)
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


die : Generator Int
die =
    Random.int 1 6


twoDice : Generator Int
twoDice =
    Random.map2 (+) die die


randomStats : Generator Stats
randomStats =
    Random.map Stats twoDice
        |> Random.andMap twoDice
        |> Random.andMap twoDice
        |> Random.andMap twoDice
        |> Random.andMap twoDice
        |> Random.andMap twoDice


randomAge : Generator Int
randomAge =
    Random.weighted
        ( 5, 13 )
        [ ( 10, 14 )
        , ( 15, 15 )
        , ( 20, 16 )
        , ( 50, 17 )
        , ( 100, 18 )
        ]


randomStatsAge : Generator ( Stats, Int )
randomStatsAge =
    Random.pair randomStats randomAge


rollStats : Cmd Msg
rollStats =
    Random.generate StatsRolled randomStatsAge


type Step
    = PickStats
    | PickCareer


type alias Model =
    { step : Step, stats : Stats, age : Int, selectedCareer : Career, career : Maybe Career }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { step = PickStats, stats = Stats 6 6 6 6 6 6, age = 18, selectedCareer = Career.Scouts, career = Nothing }, rollStats )



-- UPDATE


type Msg
    = RerollClicked
    | StatsRolled ( Stats, Int )
    | StatsPicked
    | CareerSelected Career
    | CareerPicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RerollClicked ->
            ( model, rollStats )

        StatsRolled ( stats, age ) ->
            ( { model | stats = stats, age = age }, Cmd.none )

        StatsPicked ->
            ( { model | step = PickCareer }, Cmd.none )

        CareerSelected c ->
            ( { model | selectedCareer = c }, Cmd.none )

        CareerPicked ->
            ( { model | career = Just model.selectedCareer }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ playerCard model
        , case model.step of
            PickStats ->
                statPicker model.stats

            PickCareer ->
                careerPicker model.selectedCareer
        ]


continueButton : Msg -> Html Msg
continueButton msg =
    Html.button [ Html.Events.onClick msg ] [ Html.text "Continue" ]


statPicker : Stats -> Html Msg
statPicker stats =
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
        , continueButton StatsPicked
        ]


careerPicker : Career -> Html Msg
careerPicker career =
    Html.div []
        [ Html.select [ Html.Events.onInput (\c -> CareerSelected <| Career.fromString c) ] <| List.map (renderCareerOpt career) Career.listCareers
        , continueButton CareerPicked
        ]


renderCareerOpt : Career -> Career -> Html msg
renderCareerOpt selected career =
    let
        careerString : String
        careerString =
            Career.toString career
    in
    Html.option [ Html.Attributes.selected (selected == career) ] [ Html.text careerString ]


toUpp : Stats -> String
toUpp stats =
    Ehex.fromInt stats.str
        ++ Ehex.fromInt stats.dex
        ++ Ehex.fromInt stats.end
        ++ Ehex.fromInt stats.int
        ++ Ehex.fromInt stats.edu
        ++ Ehex.fromInt stats.soc


playerCard : Model -> Html msg
playerCard model =
    let
        career : String
        career =
            case model.career of
                Just c ->
                    Career.toString c

                Nothing ->
                    "None"
    in
    Html.div [ Html.Attributes.id "player-card" ]
        [ Html.div [] [ Html.text ("UPP: " ++ toUpp model.stats ++ " Age: " ++ String.fromInt model.age) ]
        , Html.div []
            [ Html.text
                ("Service: "
                    ++ career
                )
            ]
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = always Sub.none }

module Main exposing (main)

import Browser
import Html exposing (Html)



-- MAIN


main : Program () Int Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = always Sub.none }



-- MODEL


init : () -> ( Int, Cmd Msg )
init _ =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Int -> ( Int, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Int -> Html msg
view _ =
    Html.div [] [ Html.text "Hello World" ]

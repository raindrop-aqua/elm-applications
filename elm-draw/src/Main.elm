module Main exposing (Model, Msg(..), init, update, view)

import Browser
import Color
import Html exposing (Html, div, p, text)
import Html.Attributes
import Html.Events.Extra.Mouse as Mouse
import TypedSvg exposing (rect, svg)
import TypedSvg.Attributes exposing (stroke, viewBox)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { mousepos : ( Float, Float )
    }


init : Model
init =
    { mousepos = ( 0, 0 ) }



-- UPDATE


type Msg
    = VBoxMove ( Float, Float )


update : Msg -> Model -> Model
update msg model =
    case msg of
        VBoxMove ( x, y ) ->
            { model | mousepos = ( x, y ) }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text <| Debug.toString model.mousepos ]
        , svgArea model
        ]


svgArea model =
    svg
        [ Html.Attributes.style "background-color" "ghostwhite"
        , Html.Attributes.style "border" "1px solid black"
        , width 500
        , height 500
        , viewBox 0 0 500 500
        , Mouse.onMove (\event -> VBoxMove event.offsetPos)
        ]
        [ rect
            [ stroke <| Color.black
            , height 50
            , width 50
            , x <| Tuple.first model.mousepos
            , y <| Tuple.second model.mousepos
            ]
            []
        ]

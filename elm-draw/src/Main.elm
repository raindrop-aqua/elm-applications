module Main exposing (Model, Msg(..), init, update, view)

import Browser
import Color
import Html exposing (Html, div, p, text)
import Html.Attributes
import Html.Events.Extra.Mouse as Mouse
import TypedSvg exposing (circle, rect, svg)
import TypedSvg.Attributes exposing (fill, stroke, viewBox)
import TypedSvg.Attributes.InPx exposing (cx, cy, height, r, width, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..))


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type ShapeKind
    = None
    | Rectangle
    | Circle


type alias Model =
    { mousePos : ( Float, Float )
    , shapes : List Shape
    , mouseDownPos : ( Float, Float )
    }


type alias Shape =
    { kind : ShapeKind
    , posX : Float
    , posY : Float
    }


init : Model
init =
    { mousePos = ( 0, 0 )
    , shapes =
        [ { kind = Rectangle, posX = 10, posY = 20 }
        , { kind = Circle, posX = 200, posY = 350 }
        , { kind = None, posX = 110, posY = 110 }
        ]
    , mouseDownPos = ( 0, 0 )
    }



-- UPDATE


type Msg
    = VBoxMove ( Float, Float )
    | Click ( Float, Float )


update : Msg -> Model -> Model
update msg model =
    case msg of
        VBoxMove ( x, y ) ->
            { model | mousePos = ( x, y ) }

        Click ( x, y ) ->
            { model
                | mouseDownPos = ( x, y )
                , shapes = createShape x y :: model.shapes
            }


createShape : Float -> Float -> Shape
createShape x y =
    { kind = Rectangle
    , posX = x
    , posY = y
    }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text <| showStatus model ]
        , svgArea model
        ]


svgArea : Model -> Html Msg
svgArea model =
    svg
        [ Html.Attributes.style "background-color" "ghostwhite"
        , Html.Attributes.style "border" "1px solid black"
        , width 500
        , height 500
        , viewBox 0 0 500 500
        , Mouse.onMove (\event -> VBoxMove event.offsetPos)
        , Mouse.onDown (\event -> Click event.offsetPos)
        ]
        (List.map showShape model.shapes)


showShape : Shape -> Svg Msg
showShape shape =
    case shape.kind of
        None ->
            text ""

        Rectangle ->
            rect
                [ fill <| Fill Color.blue
                , stroke <| Color.black
                , height 50
                , width 50
                , x shape.posX
                , y shape.posY
                ]
                []

        Circle ->
            circle
                [ fill <| Fill Color.blue
                , stroke <| Color.black
                , r 25
                , cx shape.posX
                , cy shape.posY
                ]
                []


showStatus : Model -> String
showStatus model =
    "Position:"
        ++ Debug.toString model.mousePos
        ++ "| Clicked Position:"
        ++ Debug.toString model.mouseDownPos

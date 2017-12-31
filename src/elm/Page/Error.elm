module Page.Error exposing (Model, view, Styles(..), styles)

import Element
import Style exposing (..)


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None []
    ]


type alias Model =
    String


view : Model -> Element.Element Styles variation msg
view model =
    Element.text "Error"

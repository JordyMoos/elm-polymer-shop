module View.Header exposing (Styles(..), styles, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Color
import Style.Color as Color
import Style.Border as Border


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None []
    ]


view : Element Styles variation msg
view =
    el
        None
        []
        (link "#" <| text "Header")

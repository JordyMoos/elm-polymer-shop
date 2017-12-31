module Page.NotFound exposing (view, Styles(..), styles)

import Element
import Style exposing (..)


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None []
    ]


view : Element.Element Styles variation msg
view =
    Element.text "Not found"

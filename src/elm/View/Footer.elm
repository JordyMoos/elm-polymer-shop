module View.Footer exposing (Styles(..), styles, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Color
import Style.Color as Color
import Style.Border as Border


type Styles
    = None
    | Footer
    | DemoLabel


styles : List (Style Styles variation)
styles =
    [ style None []
    , style Footer []
    , style DemoLabel
        [ Color.background <| Color.rgb 32 32 32
        , Color.text Color.white
        ]
    ]


view : Element Styles variation msg
view =
    footer
        Footer
        [ paddingTop 20.0, center ]
        (column None
            [ center, spacing 8.0 ]
            [ newTab "https://www.polymer-project.org/2.0/toolbox/" <|
                el None [] (text "Made by Elm and Polymer")
            , el DemoLabel [ center, padding 6.0, width <| px 120 ] <| text "Demo Only"
            ]
        )

module Page.Category.Category exposing (Model, init, view, Styles(..), styles)

import Data.Category as Category
import Data.Item as Item
import Element
import Element.Attributes as Attributes
import Style exposing (..)


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None []
    ]


type alias Model =
    { category : Category.Category
    , items : List Item.Item
    }


init : Model -> ( Model, Cmd msg )
init model =
    model ! []


view : Model -> Element.Element Styles variation msg
view model =
    Element.el None [] (Element.text "Category page")

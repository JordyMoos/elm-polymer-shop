module Page.Home exposing (view, Styles(..), styles)

import Data.Category as Category
import Element
import Element.Attributes as Attributes
import Style exposing (..)


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None []
    ]


view : Element.Element Styles variation msg
view =
    Element.wrappedColumn
        None
        []
        viewCategories


viewCategories : List (Element.Element Styles variation msg)
viewCategories =
    List.map viewCategory Category.categories


viewCategory : Category.Category -> Element.Element Styles variation msg
viewCategory category =
    Element.row
        None
        []
        [ Element.text "Image here"
        , Element.h2 None [] (Element.text category.title)
        , Element.text "Button here"
        ]

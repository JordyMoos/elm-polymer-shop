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
    Element.wrappedRow
        None
        []
        viewCategories


viewCategories : List (Element.Element Styles variation msg)
viewCategories =
    List.map viewCategory <| List.indexedMap (,) Category.categories


viewCategory : ( Int, Category.Category ) -> Element.Element Styles variation msg
viewCategory ( index, category ) =
    let
        attributes =
            if index > 1 then
                [ Attributes.width <| Attributes.percent 50 ]
            else
                []
    in
        Element.column
            None
            attributes
            [ Element.node
                "shop-image"
                (Element.el
                    None
                    [ Attributes.attribute "src" category.image
                    , Attributes.attribute "alt" category.title
                    , Attributes.attribute "placeholder-img" category.placeholder
                    ]
                    Element.empty
                )
            , Element.h2 None [] (Element.text category.title)
            , Element.text "Button here"
            ]

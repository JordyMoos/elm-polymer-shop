module Page.Home exposing (view, Styles(..), styles)

import Data.Category as Category
import Element
import Element.Attributes as Attributes
import Style exposing (..)
import Style.Font as Font
import Html


type Styles
    = None
    | Title


styles : List (Style Styles variation)
styles =
    [ style None []
    , style Title
        [ Font.size 17
        , Font.weight 500
        ]
    ]


view : Element.Element Styles variation msg
view =
    Element.wrappedRow
        None
        [ Attributes.spacingXY 0 40 ]
        viewCategories


viewCategories : List (Element.Element Styles variation msg)
viewCategories =
    List.map viewCategory <| List.indexedMap (,) Category.categories


viewCategory : ( Int, Category.Category ) -> Element.Element Styles variation msg
viewCategory ( index, category ) =
    let
        attributes =
            if index > 1 then
                [ Attributes.center
                , Attributes.width <| Attributes.percent 50
                ]
            else
                [ Attributes.center
                ]
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
            , Element.h2 Title [ Attributes.paddingXY 0 32 ] (Element.text category.title)
            , Element.node
                "shop-button"
                (Element.el
                    None
                    [ Attributes.attribute "href" <| Category.url category ]
                    (Element.text "SHOP NOW")
                )
            ]

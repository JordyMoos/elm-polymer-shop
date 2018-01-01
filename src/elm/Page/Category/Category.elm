module Page.Category.Category exposing (Model, init, view, Styles(..), styles)

import Data.Category as Category
import Data.Item as Item
import Element exposing (..)
import Element.Attributes exposing (..)
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
    column
        None
        []
        [ categoryImage model.category
        , categoryHeader model
        , itemsContainer model.items
        ]


categoryImage : Category.Category -> Element.Element Styles variation msg
categoryImage category =
    node "shop-image"
        (el None
            [ attribute "src" category.image
            , attribute "alt" category.title
            , attribute "placeholder-img" category.placeholder
            ]
            empty
        )


categoryHeader : Model -> Element.Element Styles variation msg
categoryHeader { category, items } =
    header None [] <|
        column None
            []
            [ categoryTitle category.title
            , itemCount <| List.length items
            ]


categoryTitle : String -> Element.Element Styles variation msg
categoryTitle title =
    h1 None [] (text title)


itemCount : Int -> Element.Element Styles variation msg
itemCount count =
    el None [] <|
        text <|
            String.concat [ "(", (toString count), " items)" ]


itemsContainer : List Item.Item -> Element.Element Styles variation msg
itemsContainer items =
    wrappedRow None [] <|
        List.map itemContainer items


itemContainer : Item.Item -> Element.Element Styles variation msg
itemContainer item =
    link (Item.url item) <|
        node "shop-list-item" <|
            el None
                [ attribute "title" item.title
                , attribute "image" item.image
                , attribute "placeholder" item.image
                , attribute "price" <| toString item.price
                ]
                empty

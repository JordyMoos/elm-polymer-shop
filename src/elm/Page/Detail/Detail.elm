module Page.Detail.Detail exposing (Model, init, view, Styles(..), styles)

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
    , item : Item.Item
    }


init : Model -> ( Model, Cmd msg )
init model =
    model ! []


view : Model -> Element.Element Styles variation msg
view { category, item } =
    node "shop-detail" <|
        el None
            [ attribute "name" item.name
            , attribute "title" item.title
            , attribute "category" item.category
            , attribute "price" <| toString item.price
            , attribute "description" item.description
            , attribute "image" item.image
            , attribute "largeImage" item.largeImage
            ]
            empty

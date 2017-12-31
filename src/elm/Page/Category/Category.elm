module Page.Category.Category exposing (Model, init, view)

import Data.Category as Category
import Data.Item as Item
import Element
import Element.Attributes as Attributes


type alias Model =
    { category : Category.Category
    , items : List Item.Item
    }


init : Model -> ( Model, Cmd msg )
init model =
    model ! []


view : Model -> Element.Element styles variation msg
view model =
    Element.text "Category page"

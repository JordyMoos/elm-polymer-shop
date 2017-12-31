module Page.Error exposing (Model, view)

import Element


type alias Model =
    String


view : Model -> Element.Element styles variation msg
view model =
    Element.text "Error"

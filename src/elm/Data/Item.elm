module Data.Item exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Item =
    { name : String
    , title : String
    , category : String
    , price : Float
    , description : String
    , image : String
    , largeImage : String
    }


empty : Item
empty =
    { name = ""
    , title = ""
    , category = ""
    , price = 0.0
    , description = ""
    , image = ""
    , largeImage = ""
    }


listDecoder : Decoder (List Item)
listDecoder =
    Decode.list decoder


decoder : Decoder Item
decoder =
    decode Item
        |> required "name" Decode.string
        |> required "title" Decode.string
        |> required "category" Decode.string
        |> required "price" Decode.float
        |> required "description" Decode.string
        |> required "image" Decode.string
        |> required "largeImage" Decode.string


url : Item -> String
url { category, name } =
    String.concat
        [ "#/detail/"
        , category
        , "/"
        , name
        ]

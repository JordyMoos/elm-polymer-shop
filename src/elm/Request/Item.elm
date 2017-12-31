module Request.Item exposing (getByCategory)

import Http
import Data.Item as Item
import RemoteData
import Request.Helpers exposing (apiUrl)


getByCategory :
    (RemoteData.WebData (List Item.Item) -> msg)
    -> String
    -> Cmd msg
getByCategory tagger categoryName =
    Http.get (byCategoryUrl categoryName) Item.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map tagger


byCategoryUrl : String -> String
byCategoryUrl categoryName =
    apiUrl ("/" ++ categoryName ++ ".json")

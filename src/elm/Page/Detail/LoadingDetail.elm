module Page.Detail.LoadingDetail exposing (Model, Msg(..), init, update)

import Data.Item as Item
import Data.Category as Category
import Request.Item as ItemRequest
import RemoteData exposing (WebData)
import Page.Detail.Detail as DetailPage
import PageLoader exposing (TransitionStatus(Pending, Success, Failed))
import PageLoader.DependencyStatus as DependencyStatus
import PageLoader.DependencyStatus.RemoteDataExt as RemoteDataExt
import Ext.PageLoader.PageLoaderExt as PageLoaderExt
import List.Extra
import Http


type alias Model =
    { categoryName : String
    , category : Maybe Category.Category
    , itemName : String
    , item : WebData (Maybe Item.Item)
    }


type Msg
    = ItemResponse (WebData (List Item.Item))


init : String -> String -> TransitionStatus Model Msg DetailPage.Model
init categoryName itemName =
    asTransitionStatus <|
        { categoryName = categoryName
        , category = Category.byName categoryName
        , itemName = itemName
        , item = RemoteData.Loading
        }
            ! [ ItemRequest.getByCategory ItemResponse categoryName
              ]


update : Msg -> Model -> TransitionStatus Model Msg DetailPage.Model
update msg model =
    asTransitionStatus <|
        case msg of
            ItemResponse response ->
                { model | item = RemoteData.map (List.Extra.find (\item -> item.name == model.itemName)) response } ! []


asTransitionStatus :
    ( Model, Cmd Msg )
    -> TransitionStatus Model Msg DetailPage.Model
asTransitionStatus ( model, cmd ) =
    PageLoader.defaultDependencyStatusListHandler
        ( model, cmd )
        (dependencyStatuses model)
        (\() ->
            { category = Maybe.withDefault Category.empty model.category
            , item =
                RemoteData.withDefault Nothing model.item
                    |> Maybe.withDefault Item.empty
            }
        )


dependencyStatuses : Model -> List DependencyStatus.Status
dependencyStatuses model =
    [ case model.item of
        RemoteData.Success maybeItem ->
            PageLoaderExt.maybeAsStatus maybeItem

        remoteDataItem ->
            RemoteDataExt.asStatus remoteDataItem
    ]

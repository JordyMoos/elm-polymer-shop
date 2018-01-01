module Page.Category.LoadingCategory exposing (Model, Msg(..), init, update)

import Data.Item as Item
import Data.Category as Category
import Request.Item as ItemRequest
import RemoteData exposing (WebData)
import Page.Category.Category as CategoryPage
import PageLoader exposing (TransitionStatus(Pending, Success, Failed))
import PageLoader.DependencyStatus as DependencyStatus
import PageLoader.DependencyStatus.RemoteDataExt as RemoteDataExt


type alias Model =
    { categoryName : String
    , category : Maybe Category.Category
    , items : WebData (List Item.Item)
    }


type Msg
    = ItemsResponse (WebData (List Item.Item))


init : String -> TransitionStatus Model Msg CategoryPage.Model
init categoryName =
    asTransitionStatus <|
        { categoryName = categoryName
        , category = Category.byName categoryName
        , items = RemoteData.Loading
        }
            ! [ ItemRequest.getByCategory ItemsResponse categoryName
              ]


update : Msg -> Model -> TransitionStatus Model Msg CategoryPage.Model
update msg model =
    asTransitionStatus <|
        case msg of
            ItemsResponse response ->
                { model | items = response } ! []


asTransitionStatus :
    ( Model, Cmd Msg )
    -> TransitionStatus Model Msg CategoryPage.Model
asTransitionStatus ( model, cmd ) =
    PageLoader.defaultDependencyStatusListHandler
        ( model, cmd )
        (dependencyStatuses model)
        (\() ->
            { category = Maybe.withDefault Category.empty model.category
            , items = RemoteData.withDefault [] model.items
            }
        )


dependencyStatuses : Model -> List DependencyStatus.Status
dependencyStatuses model =
    [ RemoteDataExt.asStatus model.items
    ]

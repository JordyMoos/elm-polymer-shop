module Main exposing (..)

import Html exposing (Html)
import Routing
import Page.NotFound as NotFound
import Page.Blank as Blank
import Page.Error as Error
import Page.Home as Home
import Page.Category.Category as Category
import Page.Category.LoadingCategory as LoadingCategory
import Page.Detail.Detail as Detail
import Page.Detail.LoadingDetail as LoadingDetail
import PageLoader exposing (PageState(Loaded, Transitioning), TransitionStatus(..))
import PageLoader.Progression as Progression
import Navigation
import Element
import Style
import View.Header as Header
import View.Footer as Footer
import Style.Sheet as Sheet
import Style.Font as Font
import Util.Util exposing (keepMsg, keepVariation)


type Page
    = BlankPage
    | NotFoundPage
    | ErrorPage Error.Model
    | HomePage
    | CategoryPage Category.Model
    | DetailPage Detail.Model


type Loading
    = LoadingCategory LoadingCategory.Model Progression.Progression
    | LoadingDetail LoadingDetail.Model Progression.Progression


type alias Model =
    { pageState : PageState Page Loading
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    setRoute (Routing.fromLocation location) initModel


initModel : Model
initModel =
    { pageState = Loaded BlankPage }


main : Program Never Model Msg
main =
    Navigation.program ChangeLocation
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


type Msg
    = NoOp
    | ChangeLocation Navigation.Location
    | LoadingCategoryMsg LoadingCategory.Msg
    | LoadingDetailMsg LoadingDetail.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.pageState ) of
        ( ChangeLocation location, _ ) ->
            setRoute (Routing.fromLocation location) model

        ( LoadingCategoryMsg subMsg, Transitioning oldPage (LoadingCategory subModel _) ) ->
            processLoadingCategory oldPage (LoadingCategory.update subMsg subModel)
                |> updatePageState model

        ( LoadingDetailMsg subMsg, Transitioning oldPage (LoadingDetail subModel _) ) ->
            processLoadingDetail oldPage (LoadingDetail.update subMsg subModel)
                |> updatePageState model

        ( _, _ ) ->
            ( model, Cmd.none )


setRoute : Maybe Routing.Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        oldPage =
            PageLoader.visualPage model.pageState
    in
        case maybeRoute of
            Nothing ->
                { model | pageState = Loaded NotFoundPage } ! []

            Just Routing.Home ->
                { model | pageState = Loaded HomePage } ! []

            Just (Routing.Category categoryName) ->
                processLoadingCategory oldPage (LoadingCategory.init categoryName)
                    |> updatePageState model

            Just (Routing.Detail categoryName itemName) ->
                processLoadingDetail oldPage (LoadingDetail.init categoryName itemName)
                    |> updatePageState model


processLoadingCategory : Page -> TransitionStatus LoadingCategory.Model LoadingCategory.Msg Category.Model -> ( PageState Page Loading, Cmd Msg )
processLoadingCategory =
    PageLoader.defaultProcessLoading ErrorPage LoadingCategory LoadingCategoryMsg CategoryPage Category.init (always NoOp)


processLoadingDetail : Page -> TransitionStatus LoadingDetail.Model LoadingDetail.Msg Detail.Model -> ( PageState Page Loading, Cmd Msg )
processLoadingDetail =
    PageLoader.defaultProcessLoading ErrorPage LoadingDetail LoadingDetailMsg DetailPage Detail.init (always NoOp)


updatePageState : Model -> ( PageState Page Loading, Cmd msg ) -> ( Model, Cmd msg )
updatePageState model ( pageState, cmd ) =
    ( { model | pageState = pageState }, cmd )


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage page
                |> viewWrapContent

        Transitioning oldPage transitionData ->
            viewPage oldPage
                |> viewWrapContent


viewPage : Page -> Element.Element Styles variation msg
viewPage page =
    case page of
        BlankPage ->
            Blank.view |> tagStyle BlankStyles

        NotFoundPage ->
            NotFound.view |> tagStyle NotFoundStyles

        ErrorPage model ->
            Error.view model |> tagStyle ErrorStyles

        HomePage ->
            Home.view |> tagStyle HomeStyles

        CategoryPage model ->
            Category.view model |> tagStyle CategoryStyles

        DetailPage model ->
            Detail.view model |> tagStyle DetailStyles


type Styles
    = None
    | FontFamily
    | HeaderStyles Header.Styles
    | FooterStyles Footer.Styles
    | BlankStyles Blank.Styles
    | NotFoundStyles NotFound.Styles
    | ErrorStyles Error.Styles
    | HomeStyles Home.Styles
    | CategoryStyles Category.Styles
    | DetailStyles Detail.Styles


styleSheet : Style.StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ Style.style None []
        , Style.style FontFamily
            [ Font.typeface
                [ Font.font "Roboto"
                , Font.font "Noto"
                , Font.font "sans-serif"
                ]
            , Font.size 13.0
            , Font.lineHeight 1.5
            ]
        , Sheet.map HeaderStyles keepVariation Header.styles |> Sheet.merge
        , Sheet.map FooterStyles keepVariation Footer.styles |> Sheet.merge
        , Sheet.map BlankStyles keepVariation Blank.styles |> Sheet.merge
        , Sheet.map NotFoundStyles keepVariation NotFound.styles |> Sheet.merge
        , Sheet.map ErrorStyles keepVariation Error.styles |> Sheet.merge
        , Sheet.map HomeStyles keepVariation Home.styles |> Sheet.merge
        , Sheet.map CategoryStyles keepVariation Category.styles |> Sheet.merge
        , Sheet.map DetailStyles keepVariation Detail.styles |> Sheet.merge
        ]


tagStyle : (styles -> Styles) -> Element.Element styles variation msg -> Element.Element Styles variation msg
tagStyle tagger =
    Element.mapAll keepMsg tagger keepVariation


viewWrapContent : Element.Element Styles variation msg -> Html msg
viewWrapContent content =
    Element.layout styleSheet <|
        Element.column
            FontFamily
            []
            [ Element.mapAll keepMsg HeaderStyles keepVariation Header.view
            , Element.mainContent None [] content
            , Element.mapAll keepMsg FooterStyles keepVariation Footer.view
            ]

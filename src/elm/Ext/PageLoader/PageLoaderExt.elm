module Ext.PageLoader.PageLoaderExt exposing (..)

import PageLoader.DependencyStatus as DependencyStatus
import PageLoader.Progression as Progression


maybeAsStatus : Maybe a -> DependencyStatus.Status
maybeAsStatus maybe =
    case maybe of
        Just _ ->
            DependencyStatus.Success

        Nothing ->
            DependencyStatus.Pending Progression.singlePending

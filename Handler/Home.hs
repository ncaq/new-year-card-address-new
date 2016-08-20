module Handler.Home where

import           Import
import           Text.Julius           (RawJS (..))
import           Yesod.Form.Bootstrap3 (BootstrapFormLayout (..),
                                        renderBootstrap3, withSmallInput)

getHomeR :: Handler Html
getHomeR = runDB $ do
    peopleList <- selectList [] [Desc PeopleCreatedAt]
    lift $ defaultLayout $ do
        setTitle "new year card address new"
        $(widgetFile "homepage")

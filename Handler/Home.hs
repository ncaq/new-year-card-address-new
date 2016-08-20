module Handler.Home where

import           Import
import           Yesod.Form.Bootstrap3

getHomeR :: Handler Html
getHomeR = runDB $ do
    peopleList <- selectList [] [Desc PeopleCreatedAt]
    lift $ defaultLayout $ do
        setTitle "new year card address new"
        $(widgetFile "homepage")

peopleForm :: Form People
peopleForm = renderBootstrap3 BootstrapBasicForm $ peopleNew <$>
    areq textField "郵便番号" Nothing <*>
    areq textField "住所" Nothing <*>
    areq textField "宛名" Nothing <*>
    lift (liftIO getCurrentTime) <*
    bootstrapSubmit ("追加" :: BootstrapSubmit Text)

peopleNew :: Text -> Text -> Text -> UTCTime -> People
peopleNew peopleCode peoplePlace peopleName peopleCurrentAt = People{peopleCode, peoplePlace, peopleName, peopleCreatedAt = peopleCurrentAt, peopleUpdatedAt = peopleCurrentAt}

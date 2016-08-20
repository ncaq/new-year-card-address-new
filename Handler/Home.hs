module Handler.Home where

import           Import
import           Yesod.Form.Bootstrap3

getHomeR :: Handler Html
getHomeR = postHomeR

postHomeR :: Handler Html
postHomeR = runDB $ do
    ((result, form), enctype) <- lift $ runFormPost peopleForm
    case result of
        FormSuccess people -> insert_ people
        _ -> return ()
    peopleList <- selectList [] [Desc PeopleId]
    lift $ defaultLayout $ do
        setTitle "new year card address new"
        $(widgetFile "homepage")

peopleForm :: Form People
peopleForm = renderBootstrap3 BootstrapBasicForm $ peopleNew <$>
    lift requireAuthId <*>
    areq textField "郵便番号" Nothing <*>
    areq textField "住所" Nothing <*>
    areq textField "宛名" Nothing <*>
    lift (liftIO getCurrentTime) <*
    bootstrapSubmit ("追加" :: BootstrapSubmit Text)

peopleNew :: UserId -> Text -> Text -> Text -> UTCTime -> People
peopleNew peopleOwner peopleCode peoplePlace peopleName peopleCurrentAt = People{peopleOwner, peopleCode, peoplePlace, peopleName, peopleCreatedAt = peopleCurrentAt, peopleUpdatedAt = peopleCurrentAt}

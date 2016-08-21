module Handler.Home where

import           Import
import           Yesod.Form.Bootstrap3

getHomeR :: Handler Html
getHomeR = postHomeR

postHomeR :: Handler Html
postHomeR = runDB $ do
    mUserId <- lift maybeAuthId
    case mUserId of
        Nothing -> redirect $ AuthR LoginR
        Just userId -> do
            ((result, form), enctype) <- lift $ runFormPost cardForm
            case result of
                FormSuccess card -> insert_ card
                _ -> return ()
            cardList <- selectList [CardUser ==. userId] [Desc CardId]
            lift $ defaultLayout $ do
                setTitle "身内向年賀状生成"
                $(widgetFile "homepage")

cardForm :: Form Card
cardForm = renderBootstrap3 BootstrapBasicForm $ cardNew <$>
    lift requireAuthId <*>
    areq textField "郵便番号" Nothing <*>
    areq textField "住所" Nothing <*>
    areq textField "宛名" Nothing <*>
    lift (liftIO getCurrentTime) <*
    bootstrapSubmit ("追加" :: BootstrapSubmit Text)

cardNew :: UserId -> Text -> Text -> Text -> UTCTime -> Card
cardNew cardUser cardCode cardPlace cardName cardCurrentAt = Card{cardUser, cardCode, cardPlace, cardName, cardCreatedAt = cardCurrentAt, cardUpdatedAt = cardCurrentAt}

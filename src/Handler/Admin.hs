{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Admin where

import Import
import Text.Lucius
import Text.Julius
import Database.Persist.Sql

widgetBootstrapLinks :: Widget
widgetBootstrapLinks = $(whamletFile "templates/bootstrapLinks.hamlet")

getAdminR :: Handler Html   
getAdminR = do 
    players <- runDB $ selectList [] [Asc PlayerNome]
    defaultLayout $ do 
        setTitle "Painel Admin"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/admin.lucius")
        $(whamletFile "templates/admin.hamlet")

postApagarR :: PlayerId -> Handler Html
postApagarR plaid = do 
    runDB $ deleteCascade plaid
    redirect AdminR
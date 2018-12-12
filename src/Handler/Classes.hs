{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Classes where

import Text.Lucius
import Text.Julius
import Import

widgetBootstrapLinks :: Widget
widgetBootstrapLinks = $(whamletFile "templates/bootstrapLinks.hamlet")

getClassesR :: Handler Html
getClassesR = do 
    admin <- lookupSession "_ADM"
    logado <- lookupSession "_PLA"
    defaultLayout $ do 
        setTitle "Classes"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/classes.lucius")
        $(whamletFile "templates/classes.hamlet")
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Racas where

import Text.Lucius
import Text.Julius
import Import

widgetBootstrapLinks :: Widget
widgetBootstrapLinks = $(whamletFile "templates/bootstrapLinks.hamlet")

getRacasR :: Handler Html
getRacasR = do 
    admin <- lookupSession "_ADM"
    logado <- lookupSession "_PLA"
    defaultLayout $ do 
        setTitle "Raças"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/raca.lucius")
        $(whamletFile "templates/raca.hamlet")
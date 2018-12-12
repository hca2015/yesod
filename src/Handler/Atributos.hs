{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Atributos where

import Text.Lucius
import Text.Julius
import Import

widgetBootstrapLinks :: Widget
widgetBootstrapLinks = $(whamletFile "templates/bootstrapLinks.hamlet")

getAtributosR :: Handler Html
getAtributosR = do 
    admin <- lookupSession "_ADM"
    logado <- lookupSession "_PLA"
    defaultLayout $ do 
        setTitle "Atributos | Todos Atributos"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/atributos.lucius")
        $(whamletFile "templates/atributos.hamlet")

getBonusR :: Handler Html
getBonusR = do 
    admin <- lookupSession "_ADM"
    logado <- lookupSession "_PLA"
    defaultLayout $ do 
        setTitle "Atributos | Bônus de Atributos por Raça"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/bonusAtribRaca.lucius")
        $(whamletFile "templates/bonusAtribRaca.hamlet")

getEspecialistaR :: Handler Html
getEspecialistaR = do 
    admin <- lookupSession "_ADM"
    logado <- lookupSession "_PLA"
    defaultLayout $ do 
        setTitle "Atributos | Classe Especialista"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/atribClasseEspec.lucius")
        $(whamletFile "templates/atribClasseEspec.hamlet")
        
getOfensivoR :: Handler Html
getOfensivoR = do 
    admin <- lookupSession "_ADM"
    logado <- lookupSession "_PLA"
    defaultLayout $ do 
        setTitle "Atributos | Classe Ofensivo"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/atribClasseOfensivo.lucius")
        $(whamletFile "templates/atribClasseOfensivo.hamlet")

getSuporteR :: Handler Html
getSuporteR = do 
    admin <- lookupSession "_ADM"
    logado <- lookupSession "_PLA"
    defaultLayout $ do 
        setTitle "Atributos | Classe Suporte"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/atribClasseSup.lucius")
        $(whamletFile "templates/atribClasseSup.hamlet")
        
getTanqueR :: Handler Html
getTanqueR = do 
    admin <- lookupSession "_ADM"
    logado <- lookupSession "_PLA"
    defaultLayout $ do 
        setTitle "Atributos | Classe Tanque"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        toWidget $(luciusFile "templates/atribClasseTanque.lucius")
        $(whamletFile "templates/atribClasseTanque.hamlet")


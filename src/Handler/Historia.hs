{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Historia where

import Text.Lucius
import Text.Julius
import Import

formHistoria :: Form Historia
formHistoria = renderBootstrap $ Historia 
    <$> areq textField "Texto: " Nothing
    <*> areq doubleField "Imagem: " Nothing
--escrever a data    <*> areq intField "Qt Estoque: " Nothing

getHistoriaR :: Handler Html
getHistoriaR = do 
    -- GERA O FORMULARIO NA widgetForm
    (widgetForm, enctype) <- generateFormPost formHistoria
    defaultLayout $ do 
        $(whamletFile "templates/Historia.hamlet")
    
postHistoriaR :: Handler Html 
postHistoriaR = do 
    -- LE O DIGITADO
    ((res,_),_) <- runFormPost formHistoria
    case res of 
        FormSuccess Historia -> do
            -- INSERE O Historia
            pid <- runDB $ insert Historia
            redirect ListaHistoriaR
        _ -> redirect HomeR
        
getListaHistoriaR :: Handler Html
getListaHistoriaR = do 
    -- Select * from Historia order by Historia.nome
    Historias <- runDB $ selectList [] [Asc HistoriaNome]
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/listahistoria.hamlet")

getInfoR :: HistoriaId -> Handler Html
getInfoR pid = do 
    Historia <- runDB $ get404 pid
    defaultLayout $ do 
        $(whamletFile "templates/historiaid.hamlet")
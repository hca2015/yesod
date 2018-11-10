{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Produto where

import Text.Lucius
import Text.Julius
import Import

formProduto :: Form Produto
formProduto = renderBootstrap $ Produto 
    <$> areq textField "Nome: " Nothing
    <*> areq doubleField "Preco: " Nothing
    <*> areq intField "Qt Estoque: " Nothing

getProdutoR :: Handler Html
getProdutoR = do 
    -- GERA O FORMULARIO NA widgetForm
    (widgetForm, enctype) <- generateFormPost formProduto
    defaultLayout $ do 
        $(whamletFile "templates/produto.hamlet")
    
postProdutoR :: Handler Html 
postProdutoR = do 
    -- LE O DIGITADO
    ((res,_),_) <- runFormPost formProduto
    case res of 
        FormSuccess produto -> do
            -- INSERE O PRODUTO
            pid <- runDB $ insert produto
            redirect ListaProdutoR
        _ -> redirect HomeR
        
getListaProdutoR :: Handler Html
getListaProdutoR = do 
    -- Select * from Produto order by produto.nome
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/lista.hamlet")

getInfoR :: ProdutoId -> Handler Html
getInfoR pid = do 
    produto <- runDB $ get404 pid
    defaultLayout $ do 
        $(whamletFile "templates/info.hamlet")
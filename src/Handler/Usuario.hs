{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Usuario where

import Text.Lucius
import Text.Julius
import Import

formUsuario :: Form (Usuario,Text)
formUsuario = renderBootstrap $ (,) 
    <$> (Usuario 
            <$> areq textField "Nome: " Nothing
            <*> areq emailField "E-mail: " Nothing
            <*> areq passwordField "Senha: " Nothing
        )
    <*> areq passwordField "Confirmacao de senha: " Nothing

getUsuarioR :: Handler Html
getUsuarioR = do 
    (widgetForm, enctype) <- generateFormPost formUsuario
    mensagem <- getMessage
    defaultLayout $ do 
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
        $(whamletFile "templates/usuario.hamlet")
    
postUsuarioR :: Handler Html 
postUsuarioR = do 
    ((res,_),_) <- runFormPost formUsuario
    case res of 
        FormSuccess (usuario,confirmacao) -> do
           if (usuarioSenha usuario == confirmacao) then do 
                runDB $ insert usuario
                setMessage [shamlet|
                    <h1>
                        Usuario cadastrado
                |]
                redirect HomeR
           else do 
                setMessage [shamlet|
                    <h1>
                        Senha e confirmacao não conferem
                |]
                redirect UsuarioR
        _ -> redirect UsuarioR
        
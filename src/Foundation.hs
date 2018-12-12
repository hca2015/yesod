{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module Foundation where

import Import.NoFoundation
import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Yesod.Core.Types     (Logger)
import Prelude              (read)

data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static 
    , appConnPool    :: ConnectionPool 
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }

mkYesodData "App" $(parseRoutesFile "config/routes")

mkMessage "App" "messages" "en"

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance Yesod App where
    makeLogger = return . appLogger
    authRoute _ = Just LoginR
    
    isAuthorized AdminR _ = ehAdmin
    isAuthorized (ApagarR _) _ = ehAdmin
    isAuthorized SugestoesAllR getSugestoesAllR = ehAdmin
    
    isAuthorized (SugestaoR _) _ = ehPlayer
    
    isAuthorized PlayerR _ = usuarioAnonimo
    isAuthorized LoginR _ = usuarioAnonimo
    
    isAuthorized LogoutR _ = usuarioLogado
    isAuthorized (SugestoesPlayerR _) _ = usuarioLogado
    
    isAuthorized (StaticR _) _ = return Authorized
    isAuthorized HomeR _ = return Authorized
    isAuthorized PainelR getPainelR = return Authorized
    isAuthorized AtributosR _ = return Authorized
    isAuthorized BonusR _ = return Authorized
    isAuthorized EspecialistaR _ = return Authorized
    isAuthorized SuporteR _ = return Authorized
    isAuthorized OfensivoR _ = return Authorized
    isAuthorized TanqueR _ = return Authorized
    isAuthorized RacasR _ = return Authorized
    isAuthorized ClassesR _ = return Authorized
    
    isAuthorized _ _ = return $ Unauthorized "Não autorizado"
    
    

instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

instance HasHttpManager App where
    getHttpManager = appHttpManager

ehAdmin :: Handler AuthResult
ehAdmin = do 
    player <- lookupSession "_PLA"
    case player of
        Just _ -> return $ Unauthorized "Acesso negado!"
        Nothing -> do
            logado <- lookupSession "_ADM"
            case logado of 
                Just stringPlayer -> do 
                    player <- return $ read $ unpack stringPlayer
                    if (playerNome player) == "admin" then do 
                        return Authorized
                    else 
                        return $ Unauthorized "Acesso negado!"
                Nothing -> return $ Unauthorized "Apenas administradores podem acessar esta área"
    

ehPlayer :: Handler AuthResult
ehPlayer = do
    logado <- lookupSession "_PLA"
    case logado of
        Just _ -> return Authorized
        Nothing -> return $ Unauthorized "Apenas players podem enviar sugestões"
        
usuarioLogado :: Handler AuthResult
usuarioLogado = do
    admin <- lookupSession "_ADM"
    case admin of
        Just _ -> return Authorized
        Nothing -> do
            player <- lookupSession "_PLA"
            case player of
                Just _ -> return Authorized
                Nothing -> return AuthenticationRequired
                
usuarioAnonimo :: Handler AuthResult
usuarioAnonimo = do
    admin <- lookupSession "_ADM"
    case admin of
        Just _ -> redirect HomeR
        Nothing -> do
            player <- lookupSession "_PLA"
            case player of
                Just _ -> redirect HomeR
                Nothing -> return Authorized
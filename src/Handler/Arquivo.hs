{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Arquivo where

import Import
import Database.Persist.Postgresql
-- Field Settings deixa vc setar atributos em uma tag input.
-- Nesse caso, queremos soh jpg
-- FileInfo eh o tipo Arquivo.
formArquivo :: Form FileInfo
formArquivo = renderBootstrap $ areq fileField 
                           FieldSettings{fsId=Just "hident1",
                                         fsLabel="Arquivo: ",
                                         fsTooltip= Nothing,
                                         fsName= Nothing,
                                         fsAttrs=[("accept","image/jpeg")]} 
                           Nothing

getArquivoR :: Handler Html
getArquivoR = do 
    (widget,enctype) <- generateFormPost formArquivo
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <form action=@{ArquivoR} method=post enctype=#{enctype}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postArquivoR :: Handler Html 
postArquivoR = do 
    ((res,_),_) <- runFormPost formArquivo
    case res of 
        FormSuccess arq -> do 
            -- Adiciona um arquivo ao servidor. E pronto!
            -- fileName extrai o nome do arquivo
            -- Para mostrar em uma tag img o arquivo mandado,
            -- basta fazer <img src="static/img/imagem.jpg">
            -- Nao eh possivel usar StaticR, dado que, as imagens
            -- sao dinamicas e nao estaticas.
            -- liftIO troca de monada: IO por Handler
            -- fileMove envia, de fato, o arquivo ao servidor.
            liftIO $ fileMove arq ("static/" ++ (unpack $ fileName arq))
            redirect HomeR
        _ -> redirect HomeR
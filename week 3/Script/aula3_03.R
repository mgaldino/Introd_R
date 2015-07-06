## Aula 03-02
## Manipulação de dados com Dplyr

## Primeiro, vamos pegar alguns daods de escolas, via API

## Dados estão em formato JSON, que significa Java Script Object Notation
## Formato muito comum de armazenar dados
## Exemplo de formato

## { "nome": ["Manoel", "Natália"] , "idade": [ "34", "31" ] }
# seria uma tabela, com duas colunas nome e idade
# e duas linhas


library(RJSONIO)
library(jsonlite)

url <- "http://educacao.dadosabertosbr.com/api/escolas/buscaavancada?estado=al&dependenciaAdministrativa=2"

educAlagoas <- jsonlite::fromJSON(url)
df <- educAlagoas[[2]]
names(df)
dim(df)
head(df)

## Introdução ao dplyr

# A lógica do dplyr é que cada manipulação tem um verbo, ou comando, que executa a manipulação
## Principais verbos

# filter() (and slice())
# arrange()
# select() (and rename())
# distinct()
# mutate() (and transmute())
# summarise()

# exemplos
library(dplyr)

# filter é como subset ou filtro do excel.
# Primeiro argumento é o data.frame, demais são as condições de filtro

maceio <- filter(df, cidade =="MACEIO")
# validando
unique(df$cidade)
unique(maceio$cidade)

setwd("D:\\2015\\Cursos\\R\\TB\\aulas\\Introd_R\\week 3\\Dados")

load("contrib.RData")

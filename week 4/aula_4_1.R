## Aula 04 - 01
## Tidyr

# conceito principal: tidy data
## tidy: arrumado, ordenado, bem disposto....

# tidy data são dados bem arrumados
## Conceitos
## banco de dados são formados por valores
## valores são organizados em variáveis e observações
## variável é um atributo (receita, cargo etc.)
## observação é todas as medidas de um indivíduo/unidade 
## (as medidas de um deputado no que tange a receita, cargo etc.)
## assim, a receita de um deputado forma um valor (par variável, observação)
# cada coluna é uma variável, cada linha é uma observação


library(dplyr)
library(tidyr)
## exemplo (Adaptado de http://blog.rstudio.org/2014/07/22/introducing-tidyr/)

## Vamos imaginar o seguinte banco de dados
## Damos a 4 pessoas duas drogas (A e B), e testamos o batimento cardíacos delas.
, com o nome deles, gênero e contribuição de campanha

dados0 <- data.frame(nome= c("Alceu", "João", "Maria", "Tina"),
                     A = c( 70, 87, 83, 96),
                     B= c( 73, 82, 90, 99))

dados0

## Nós temos três variáveis, nome, receita, e gênero, mas so nome está como coluna.

dados0 %>%
  gather(droga, batimento, A:B)

# transformaçÃo de wide para long

dados1 <- data.frame(nome= c("Alceu", "João", "Maria", "Tina"),
                             genero = c( "Male", "Male", "Female", "Female"),
                             receita= round(runif(4, 0, 100000), 2))
dados1

# Aqui, temos 



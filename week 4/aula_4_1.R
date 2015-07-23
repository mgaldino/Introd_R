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
# com o nome deles, gênero e contribuição de campanha

dados0 <- data.frame(nome= c("Alceu", "João", "Maria", "Tina"),
                     A = c( 70, 87, 83, 96),
                     B= c( 73, 82, 90, 99))

dados0

## Nós temos três variáveis, nome, receita, e gênero, mas só nome está como coluna.

dados0 %>%
  gather(droga, batimento, A:B)

# transformaçÃo de long para wide

dados1 <- dados0 %>%
  gather(droga, batimento, A:B)

dados1 %>% 
  spread(droga, batimento)

dados1 %>% 
  spread(nome, batimento)

# Função separate
## separa uma coluna em múltiplas colunas
## separate(data, col, into, sep)
## data é o df
## col é a coluna a separar, nome dela
## into (nome das novas variáveis. Pelo menos dois. Um vetor)
## separador

df <- data.frame(x = c("a-b", "a-d", "b-c"))
df
df %>% separate(col=x, into=c("A", "B"))
# sep default é qualquer sequncia de valores não-alphanuméricos
df %>% separate(x, c("A", "B"), "-")


# se cada linha não se separa no mesmo número de colunas, 
# argumento extra controla o que acontece

df <- data.frame(x = c("a", "a b", "a b c", NA))
df
df %>% separate(x, c("a", "b"), extra = "merge")
df %>% separate(x, c("a", "b"), extra = "drop")

## separador é espaço

# If only want to split specified number of times use extra = "merge"
df <- data.frame(x = c("x: 123", "y: error: 7"))
df
df %>% separate(x, c("key", "value"), sep=": ", extra = "merge")

## exemplo mais real

setwd("D:\\2015\\Cursos\\R\\TB\\aulas\\Introd_R\\week 3\\Dados")
load("contrib.RData")

head(base)

## pegando so um pedaço dos dados, pra ilustrar mais fácil

base1 <- base %>%
  select(cpf=CPF.do.candidato, sigla, nome, coligacao, status_eleito, receita) %>%
  slice(1:50)

dim(base1)
head(base1)

base2 <- base1 %>% separate( col=coligacao, into=c("Partido1", "Demais partidos"), 
                    sep="/", extra="merge")

head(base2)

# exercício
# determinar, em base1, quem se candidatou sozinho, quem se candidatou em coligação



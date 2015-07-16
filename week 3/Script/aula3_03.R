## Aula 03-02
## Manipulação de dados com Dplyr

## carregandos dados
setwd("D:\\2015\\Cursos\\R\\TB\\aulas\\Introd_R\\week 3\\Dados")

load("contrib.RData")
# carregamos df base
head(base)
names(base)

# vamos trabalhar com esses dados

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

# Vamos filtrar o banco com os candidatos do RJ
rj <- filter(base, UF=="RJ")

# validando
unique(base$UF)
unique(rj$uf)

# podemos ter mais de um filtro
# exemplos, cadndidatos do PT e do rj

rjPT <- filter(base, UF=="RJ", sigla_partido == "PT")
View(rjPT)

# equivalente
rjPT1 <- filter(base, UF=="RJ" & sigla_partido == "PT")
all.equal(rjPT, rjPT1)

## exercício pra casa
# O que filter(base, UF=="RJ" | sigla_partido == "PT") deve retornar?

# para filtrar linhas

slice(rjPT, 1:6) # equivalente a head
slice(rj, receita < 1) # não funciona
## correto é:
filter( rj, receita < 10)


## arrange
## ordena o banco pelas colunas

arrange(rjPT, idade)
arrange(rjPT, desc(idade)) # descendent order

## select
## selecionar algumas colunas

names(base)

base1 <- select(base,  CPF.do.candidato, nome, sigla, uf, cargo, genero, 
                escolaridade, idade, cor, status_eleito, receita) 

head(base1) # alterei ordem das colunas. Nome veio pra frente

# outros selects
aux <- head(base)
# todas as colunas entre sigla e nome, inclusive
select(aux, sigla:nome)

select(aux, -(sigla:nome)) # menos essas colunas

## alguns argumentos úteis
select( aux, starts_with("nome"))
select( aux, matches("si"))
# ver o help pra mais ajuda

# renomear
# mudar nome variável cpf
select(aux, cpf=CPF.do.candidato, nome, sigla, uf, cargo, genero, 
       escolaridade, idade, cor, status_eleito, receita)

# cuidado ao renomear dentro do select. Se quer manter todas variáveis e 
# renomear uma ou outra, use rename

rename(aux, cpf=CPF.do.candidato) # não alterou no banco
# retorna o data.frame com o nome alterado, mas não altera o original

# pra alterar no banco
aux <- rename(aux, cpf=CPF.do.candidato )
names(aux)

## selecionar únicos
## útil pra validar e outras coisas
distinct(select(aux, cpf))

# job, excluir cpfs repetidos
# várias maneiras de fazer, vamos usar dply

# primeiro vou mudar o nome da variável cpf, pra digitar menos
base <- rename(base, cpf=CPF.do.candidato )
baseUnica <- distinct(base, cpf)

# validando
dim(select(base, cpf))
dim(select(baseUnica, cpf))

## Adicionando novas colunas
## mutate

# quais candidatos n tiveram receita?
# vou criar nova coluna, bolReceita (variável booleana, 0 ou 1, se tem receita)
base2 <- mutate(base, bolReceita = receita > 0)
head(base2)

# quero zero ou 1, não T ou F
base2 <- mutate(base, bolReceita = as.numeric(receita > 0))
head(base2)

# posso adicionar várias variáveis de uma vez

base2 <- mutate(base, bolReceita = as.numeric(receita > 0),
                receitaAlta = receita > mean(receita))
head(base2)

# se quisermos apenas as novas variáveis, n preciso usar select
## transmute
aux2 <- transmute(aux, bolReceita = as.numeric(receita > 0),
                receitaAlta = receita > mean(receita))
head(aux2)
# n muito feliz. Vou criar receitaAltaRobusta e manter original
aux2 <- transmute(aux, receita=receita, bolReceita = as.numeric(receita > 0),
                  receitaAlta = receita > mean(receita),
                  receitaAltaRobusta = receita > median(receita))
head(aux2)

# last, but not leas, summarise
# transforma a tabela numa única linha (soma, tira média)

summarise(base, receitaMedia = mean(receita), receitaMediana=median(receita))

## Todos os verbos compartilham algumas características

## 1. O primeiro argumento é uma tabela/data.frame
## 2. os argumentos seguintes descrevem o que fazer com a tabela e 
## podemos acessar o nome da variável sem $
## 3. os verbos sempre retornam uma tabela

## isso permite encadearmos vários verbos

## E é poderoso quando usamos o operador group_by

## Quando fazemos uma tabela dinâmica, o que em geral queremos fazer é
## aplicar o que chamamos de estratégia split, apply, combine
## ou seja

## 1. Split (divida) o banco de dados de acordo com uma ou mais variáveis
## 2. aplique uma função em cada um dos sub banco de dados
## 3. combine tudo num novo banco

# exemplo. Quero a receita média dos deputados por estado
# Poderia ter um banco de dados para cada estado (passo split)
# depois calcular a receita média em cada banco (estado)
# depois agrupar os resultados num único banco (menor), com a receita por estado

## em sintaxe do R. Quero agrupar a receita média por estado

## Passo 1: split (group_by)

by_estado <- group_by(base, UF)
dim(by_estado)
dim(base)

rec_estado <- summarise(by_estado, receitaMedia = mean(receita))
rec_estado

# ou talvez a gente queira por estado e genero

by_estado_genero <- group_by(base, UF, genero)
rec_estado_genero <- summarise(by_estado_genero, receitaMedia = mean(receita))
head(rec_estado_genero)

## se eu quiser saber quais estados têm o menor gap entre mulher e homem? 
## Muito complexo de fazer am abestrato

## facó um exemplo da estratégia split-apply-combine
## depois generalizo, por induçÃo

# vamos fazer pro Acre?
tmp <- filter(rec_estado_genero, UF == "AC")
tmp

# vou criar nova variável, com o gap do estado
summarise(tmp, gap = max(receitaMedia) - min(receitaMedia))

# validando
rec_estado_genero$receitaMedia[2] - rec_estado_genero$receitaMedia[1]

## funfando

# preciso fazer isso para cada estado
gap_genero_group <- group_by(rec_estado_genero, UF)
summarise(gap_genero_group, gap = max(receitaMedia) - min(receitaMedia))

# nota: não atribuí pra um data.frame, portanto não salvei na memória
gap_uf <- summarise(gap_genero_group, gap = max(receitaMedia) - min(receitaMedia))
gap_uf <- arrange(gap_uf, gap )
gap_uf

# tem um NA ali, vamso remover o NA?
# do banco original
base <- filter(base, !is.na(UF)) # neguei o is.na

## agora podemos rodar tudo de novo

by_estado_genero <- group_by(base, UF, genero)
rec_estado_genero <- summarise(by_estado_genero, receitaMedia = mean(receita))

gap_genero_group <- group_by(rec_estado_genero, UF)

gap_uf <- summarise(gap_genero_group, gap = max(receitaMedia) - min(receitaMedia))
gap_uf <- arrange(gap_uf, gap )
gap_uf

# sem NA!!!

## Exercícios
## 1. Comparem a receita média de homens e mulheres entre eleitos e não-eleitos
## 2. Comparem entre eleitos e não eleitos, homens e mulheres, por cargo. Qual tem menor gap?


## Vamos determinar quantas mulheres e homem em cada estado, além do gap?


by_estado_genero <- group_by(base, UF, genero)

# aqui vamos usar n()
rec_estado_genero <- summarise(by_estado_genero, receitaMedia = mean(receita), 
                               qtdeCandidatos = n())
## receita e qtde de candidatos
rec_estado_genero

## será que há correlação entre rceita media e num de candidatos?

gap_genero_group <- group_by(rec_estado_genero, UF)

gap_uf1 <- summarise(gap_genero_group, 
                    gap = max(receitaMedia) - min(receitaMedia),
                    qtdeCandidatos = sum(qtdeCandidatos)) # sum para somar

gap_uf1

gap_uf1 <- arrange(gap_uf1, gap )
gap_uf1
cor(gap_uf1$gap, gap_uf1$qtdeCandidatos)

## plot básico (e feio)
plot(gap_uf1$gap, gap_uf1$qtdeCandidatos )

# a proporção de homes em relação a mulheres?
# preciso criar uma nova variável
# propHomem

gap_uf2 <- summarise(gap_genero_group, 
                     gap = max(receitaMedia) - min(receitaMedia),
                     TotalCandidatos = sum(qtdeCandidatos),
                     propHomem = max(qtdeCandidatos)/TotalCandidatos)

gap_uf2                     

# vou usar round pra ficar mais bonitinho

gap_uf2 <- summarise(gap_genero_group, 
                     gap = max(receitaMedia) - min(receitaMedia),
                     TotalCandidatos = sum(qtdeCandidatos),
                     propHomem = round(max(qtdeCandidatos)/TotalCandidatos, 2))

gap_uf2 

# cor
cor(gap_uf2$gap, gap_uf2$propHomem)
## plot 
plot(gap_uf2$gap, gap_uf2$propHomem )

# Não tem relação
# Até aqui, assumimos que homem recebe mais que mulher
# se n for verdade, gap e propHomem estão sendo calculados erradamente

## vamos fazer de outro jeito
## assumindo que Mulher vem primeiro, homeme depois
## Pra garantir, vamos usar arrange

gap_genero_group1 <- arrange(gap_genero_group, UF, genero)
gap_genero_group1

gap_uf3 <- summarise(gap_genero_group1, 
                     gap = receitaMedia[2] - receitaMedia[1],
                     TotalCandidatos = sum(qtdeCandidatos),
                     propHomem = round(qtdeCandidatos[2]/TotalCandidatos, 2))

dim(gap_uf3 )
all.equal(gap_uf2$gap , gap_uf3$gap)
## estávamos errado

## vamos ver o que é diferente?
filter(gap_uf3, gap != gap_uf2$gap)

## RN
# vamos inpecionar o banco com UF e gênero nesse estado?
filter(gap_genero_group1, UF== "RN")

# De fato, mulheres maiores que homem
## algun outro jeito de checar? 
# com group_by e criando boleana, onde gap[2] < gap[1]
## Fica como exercício pra vocês.


### Pipe operator

## dplyr nao tem side-effect e deve sempre salvar o resultado
## então, combinar váriso calls requer criar objetos intermediários
## ou fazer nested calls

# pra facilitar a leitura do código, usaremos o pipe operator (então...)
## %>%

## Transformando as análises com o pipe operator

## Originalmente, fizemos assim:
by_estado_genero <- group_by(base, UF, genero)

rec_estado_genero <- summarise(by_estado_genero, receitaMedia = mean(receita), 
                               qtdeCandidatos = n())

gap_genero_group <- group_by(rec_estado_genero, UF)

gap_genero_group1 <- arrange(gap_genero_group, UF, genero)

gap_uf3 <- summarise(gap_genero_group1, 
                     gap = receitaMedia[2] - receitaMedia[1],
                     TotalCandidatos = sum(qtdeCandidatos),
                     propHomem = round(qtdeCandidatos[2]/TotalCandidatos, 2))

base %>% # pegue df base, então
  group_by(UF,genero) %>% # agrupe por uf e gênero, então
  summarise( receitaMedia = mean(receita), 
            qtdeCandidatos = n()) %>% # summarise calculando receita média e qtdecand, então
  group_by(UF) %>% # agrupe por UF e então
  arrange(UF, genero) %>% # ordene por UF e gênero, então
  summarise(gap = receitaMedia[2] - receitaMedia[1],
            TotalCandidatos = sum(qtdeCandidatos),
            propHomem = round(qtdeCandidatos[2]/TotalCandidatos, 2)) # e sumarize o resultado final
  
# E se quiser, podemos atribuir tudo pra um df


### Joins
## O dplyr também tem verbos para duas tabelas
## os joins, que servem para juntar duas tabelas
## Simples exemplo, adaptaod de https://stat545-ubc.github.io/bit001_dplyr-cheatsheet.html

super_heroes <-
  c("    name, alignment, gender,         publisher",
    " Magneto,       bad,   male,            Marvel",
    "   Storm,      good, female,            Marvel",
    "Mystique,       bad, female,            Marvel",
    "  Batman,      good,   male,                DC",
    "   Joker,       bad,   male,                DC",
    "Catwoman,       bad, female,                DC",
    " Hellboy,      good,   male, Dark Horse Comics")
super_heroes <- read.csv(text = super_heroes, strip.white = TRUE)

publishers <- 
  c("publisher, yr_founded",
    "       DC,       1934",
    "   Marvel,       1939",
    "    Image,       1992")
publishers <- read.csv(text = publishers, strip.white = TRUE)

super_heroes
publishers

## objetivo, pegar o ano de fundaçao da revista, e juntar cm superheroes

## verbos
## inner_join, left_join, right_join, full_join etc.
inner_join(super_heroes, publishers)
# perdemos Hell boy

left_join(super_heroes, publishers)

right_join(super_heroes, publishers)

anti_join(super_heroes, publishers)
# deixa o que n tem match


## More resources
# http://datasciencelv.github.io/R-UsersGroup/2nd_Meetup/dplyr-tidyr.html#/7
# https://rpubs.com/m_dev/tidyr-intro-and-demos
# http://gastonsanchez.com/work/webdata/getting_web_data_r5_json_data.pdf
# http://gastonsanchez.com/work/webdata/getting_web_data_r8_web_apis.pdf

  
  




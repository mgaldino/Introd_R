## Importando dados no R
## Job: pegar deputados federais eleitos menos votados em 2014.

## fonte: http://www.tse.jus.br/eleicoes/estatisticas/estatisticas-candidaturas-2014/estatisticas-eleitorais-2014

# Baixei, no TSE, dados de votação de deputados federais eleitos em 2014.
# o arquivo foi baixado como um csv
# copiem pra o computador de vocês o arquivo.

#agora, vamos tentar importar no R.

# primeiro, mudando diretório
setwd("D:\\2015\\Cursos\\R\\TB\\aulas\\Introd_R\\week 2\\dados")

# importanto arquivo, tentativa 0
tent0 <- read.table("resultado_-_candidatos_eleitos.csv")

tent1 <- read.table("resultado_-_candidatos_eleitos.csv",sep=";", header=T)

tent2 <- read.table("resultado_-_candidatos_eleitos.csv",sep=";", header=T,
                    dec=",")

tent3 <- read.table("resultado_-_candidatos_eleitos.csv",sep=";", header=T,
                    dec=",", fill = TRUE)

## deu certo!!

## ou, mais fácil NESTE caso

tent4 <- read.csv2("resultado_-_candidatos_eleitos.csv")

all.equal(tent3, tent4)
head(tent4)
# aparentemente, deu certo, mas...

summary(tent1)
# temos uma coluna x, que não tem info nenhuma
# o R não entendeu os espaços em branco como NA
# Votação está como texto

# Se abrirmos com o notepad++ (editor, que recomendo voces terem instalados)
# vemos que tem um ponto e vírgula a mais.
# voces podem abrir no excel o arquivo, apagar as colunas depois de Votação 
# e salvar como cvs, separado por ;


# Podemos também, no excel,
# substituir a separação de ponto (e decimal) dos arquivos.
# e tentar novamente.

# eu to sem excel, então fiz isso no notepad++ e salvei como txt

eleito <- read.table("resultado_-_candidatos_eleitos2.txt", header=T, sep=";",
                     na.strings = "") # notem o arg. na.strings
head(eleito)

## deu certo.
## Vamos ver o arquivo no R?

# visualiza mil linhas...
View(eleito)

# temos linhas com NA, que eram subtotais ou totais. 
# posso apagar no R ou no excel.

# remove subtotais. 
eleito1 <- subset(eleito, !is.na(Candidato))
View(eleito1) # deu certo

# agora, vamos preencher a uf

# estou criando um var booleana (logical), se tem ou não info de UF
eleito1$bolUF <- !is.na(eleito1$Abrangência)
head(eleito1)

# crio minha nova variável que irá ter a info de UF
eleito1$UF <- NA 

# solução.
# se tenho info de UF, basta copiar essa info pra nova variável.
# se não tenho, copio da linha anterior.

# implementando com for loop e if, em conjunto

for ( i in 1:nrow(eleito1)) {
  if (eleito1$bolUF[i] ) {
    eleito1$UF[i] <- eleito1$Abrangência[i]    
  } else {
    eleito1$UF[i] <- eleito1$UF[i-1]
  }
}

# checando se deu certo
head(eleito1, 10)
# aparentemente ok

# ordenando por menos votados
eleito1 <- eleito1[ order(eleito1$voto),]

head(eleito1)

# salvando arquivo
result <- subset(eleito1, select= c("Candidato", "UF", "Partido", "voto"))
head(result)
dim(result)
write.table(result, file="dep_menos_votados.csv", sep=";")

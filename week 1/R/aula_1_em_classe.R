x <- 1/3 + 1/3 + 1/3 - 1
y <- 1/3 + 1/3 - 1 + 1/3
z <- 1/3 - 1 + 1/3 + 1/3
w <- -1 + 1/3 + 1/3 + 1/3
x == y
x
y

all.equal(x,y)

h <- "a"


### Ponto Flutuante!

## Criando um vetor no R
x <- c(1,2,3)
x
print(x)

## Help de uma função
?c

c(4, pi, 26)

# Operações aritiméticas com vetores
x <- c(1,2,3,4,5)

y <- c(5,4,3,2,1)
x
y
x+y
x*y
y/x

## reciclando

z <- c(1,2,3)
x+z


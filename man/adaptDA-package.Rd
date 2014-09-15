\name{adaptDA-package}
\alias{adaptDA-package}
\alias{adaptDA}
\docType{package}
\title{
Adaptive Mixture Discriminant Analysis
}
\description{
The adaptive mixture discriminant analysis (AMDA) allows to adapt a model-based classifier to the situation a class represented in the test set may have not been encountered earlier in the learning phase.
}
\details{
\tabular{ll}{
Package: \tab adaptDA\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2014-09-15\cr
License: \tab GPL-2\cr
}
}
\author{
Charles Bouveyron

Maintainer: Charles Bouveyron <charles.bouveyron@parisdescartes.fr>
}
\references{
C. Bouveyron, Adaptive mixture discriminant analysis for supervised learning with unobserved classes, Journal of Classification, vol. 31(1), pp. 49-84, 2014.
}
\keyword{ package }
\examples{
set.seed(12345)

## Data simulation
data(iris)
Z.data = iris[,-5]
Z.cls = as.numeric(iris[,5])
Z.cls[as.numeric(iris[,5]==2)] = 3
Z.cls[as.numeric(iris[,5]==3)] = 2
N = 150

## Sampling
ind = sample(1:N,N)
X.data = Z.data[ind[1:(2*N/3)],]
X.cls = Z.cls[ind[1:(2*N/3)]]
X.data = X.data[X.cls!=3,]
X.cls = X.cls[X.cls!=3]
Y.data = Z.data[ind[(2*N/3+1):N],]
Y.cls = Z.cls[ind[(2*N/3+1):N]]

# Plotting the data
par(mfrow=c(2,3))#,cex.lab=0.75,cex.axis=0.75,cex.main=0.75,cex.sub=0.75)
pc = princomp(Z.data)
x = predict(pc,X.data)
y = predict(pc,Y.data)
plot(y,type='n',main='Learning data')
points(x[,1:2],col=X.cls+1,pch=19,main='Learning data')
y = predict(pc,Y.data)
plot(y[,1:2],col=1,pch=19,main='Test data')
plot(y[,1:2],col=Y.cls+1,pch=19,main='True labels of test data')

## Usual classification with QDA
c1 = qda(X.data,X.cls)
res1 = predict(c1,Y.data)
plot(y[,1:2],col=as.numeric(res1$class)+1,pch=19,main='QDA results')

## Classification with AMDAi
c2 = amdai(X.data,X.cls,model='qda')
B = rep(c(-Inf),5)
myPRMS <- vector(mode='list', length=7) # vector of lists!
for (i in 2:5){
  myPRMS[[i]] = predict(c2,Y.data,K=i)
  B[i] = myPRMS[[i]]$crit$bic
}
plot(2:5,B[2:5],type='b',xlab='Nb of components',ylab='AIC value',main='AIC values for AMDA')
res2 = myPRMS[[which.max(B)]]
plot(y[,1:2],col=res2$cls+1,pch=19,main='AMDA results')

## Classification results
cat("* Correct classification rates :\n")
cat("\tQDA:\t",sum(res1$class == Y.cls) / length(Y.cls),"\n")
print(table(res1$class,Y.cls))
cat("\tAMDAi:\t",sum(res2$cls == Y.cls) / length(Y.cls),"\n")
print(table(res2$cls,Y.cls))
}

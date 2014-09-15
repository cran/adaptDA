\name{amdat}
\alias{amdat}
\title{
Adaptive Mixture Discriminant Analysis (transductive approach)
}
\description{
The adaptive mixture discriminant analysis (AMDA) allows to adapt a model-based classifier to the situation a class represented in the test set may have not been encountered earlier in the learning phase.
}
\usage{
amdat(X, cls, Y, K, model = "qda", maxit = 25, eps = 1e-04, ...)
}
\arguments{
  \item{X}{
the learning data
}
  \item{cls}{
the known labels for the learning data
}
  \item{Y}{
the test data.
}
  \item{K}{
the number of expected classes in the test set.
}
  \item{model}{
the model to be used among "qda" or "lda". The default model is "qda".
}
  \item{maxit}{
the maximum number of iterations for the EM algorithm.
}
  \item{eps}{
the threshold value for the likelihood differences to stop the EM algorithm.
}
  \item{\dots}{
additional parameters for internal functions.
}
}

\value{
A list is returned with the following fields:
\item{model}{the used model}
\item{mean}{the updated mixture means}
\item{prop}{the updated mixture proportions}
\item{var}{the updated mixture covariance matrices}
\item{cls}{the predicted labels for the test data}
\item{P}{the posterior probabilities}
\item{crit}{the criterion values for AIC, BIC and ICL}
}
\references{
C. Bouveyron, Adaptive mixture discriminant analysis for supervised learning with unobserved classes, Journal of Classification, vol. 31(1), pp. 49-84, 2014.
}
\author{
Charles Bouveyron
}
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

## Classification with AMDAt
B = rep(c(-Inf),7)
myPRMS <- vector(mode='list', length=7) # vector of lists!
for (i in 2:5){
 myPRMS[[i]] = amdat(X.data,X.cls,Y.data,K=i)
 B[i] = myPRMS[[i]]$crit$aic
}
plot(2:5,B[2:5],type='b',xlab='Nb of components',ylab='AIC value',main='AIC values for AMDAt')
res2 = myPRMS[[which.max(B)]]
plot(y[,1:2],col=res2$cls+1,pch=19,main='AMDAt results')

## Classification results
cat("* Correct classification rates :\n")
cat("\tQDA:\t",sum(res1$class == Y.cls) / length(Y.cls),"\n")
print(table(res1$class,Y.cls))
cat("\tAMDAt:\t",sum(res2$cls == Y.cls) / length(Y.cls),"\n")
print(table(res2$cls,Y.cls))
}
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line

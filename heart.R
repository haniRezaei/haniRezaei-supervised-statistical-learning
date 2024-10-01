
library(ElemStatLearn)
data("SAheart")

summary(SAheart)

# pairs plot to visualize data
pairs(SAheart[,-ncol(SAheart)],
      col=ifelse(SAheart$chd==1,"coral","cornflowerblue"),
      lwd=1.5)

# Multiple logistic regression ####
out.lr<-glm(chd~.,data=SAheart,family="binomial")
summary(out.lr)

## "Reduced" model ####
out.lr.red<-glm(chd~tobacco+ldl+famhist+typea+age,
                data=SAheart,family="binomial")
summary(out.lr.red)

## 5-fold CV ####
err.cv<-rep(NA,5)
yhat<-rep(NA,nrow(SAheart)) # the predicted value for each observation

set.seed(1234)
folds<-sample(1:5,nrow(SAheart),replace = T)
table(folds)
for (i in 1:5){
  x.train<-SAheart[folds!=i,]
  x.test<-SAheart[folds==i,]
  y.test<-SAheart$chd[folds==i]
  
  out.cv<-glm(chd~.,x.train,family="binomial")
  phat<-predict(out.cv,newdata = x.test,type="response")
  y.hat<-ifelse(phat>0.5,1,0)
  err.cv[i]<-mean(y.hat!=y.test)
  yhat[folds==i]<-y.hat # storing the predictions
}



mean(err.cv)
table(yhat,SAheart$chd)
sens=81/160
precision=81/(81+55)


# Naive Bayes classifier ####
install.packages('klaR')
library(klaR)

x<-SAheart[,-c(5,10)] # remove the response and 
# the categorical variable
y<-SAheart[,10]
n<-nrow(SAheart)
K=5
set.seed(1234)
folds<-sample(1:K,n,replace=T)
err.cv.g<-err.cv.k<-rep(NA,K)
y.hat.g<-y.hat.k<-rep(NA,n)

for (i in 1:K){
  x.test<-x[folds==i,]
  x.train<-x[folds!=i,]
  y.test<-y[folds==i]
  y.train<-y[folds!=i]
  
  # Naive Bayes with kernel density
  out.nb.k<-NaiveBayes(x=x.train,grouping=as.factor(y.train),
                       usekernel=T)
  temp=predict(out.nb.k,newdata = x.test)$class
  err.cv.k[i]<-mean(y.test!=temp)
  y.hat.k[folds==i]<-temp

  # Naive Bayes with Gaussian density  
  out.nb.g<-NaiveBayes(x=x.train,grouping=as.factor(y.train),
                       usekernel=FALSE)
  temp=predict(out.nb.g,newdata = x.test)$class
  err.cv.g[i]<-mean(y.test!=temp)
  y.hat.g[folds==i]<-temp
}

mean(err.cv.k)
mean(err.cv.g)

table(Actual=y,NB.k=y.hat.k)
table(Actual=y,NB.g=y.hat.g)

# kNN ####
library(class)
colnames(SAheart)

x<-SAheart[,-c(5,10)] # remove famhist and chd
y<-SAheart$chd
n<-nrow(SAheart)

set.seed(1234)
index<-sample(1:n,ceiling(n/2))
train<-x[index,]
valid<-x[-index,]
train.std<-scale(train,T,T)
ytrain<-SAheart$chd[index]
ntr<-nrow(train.std)

set.seed(1234)
folds<-sample(1:5,ntr,replace = T)
k<-c(1,3,5,11,15,25,45,105)
err.cv<-matrix(NA,5,ncol=length(k),
               dimnames = list(NULL,
                               paste0("k=",k)))
for (i in 1:5){
  x.test<-train.std[folds==i,]
  x.train<-train.std[folds!=i,]
  y.train<-ytrain[folds!=i]
  y.test<-ytrain[folds==i]
  for (j in 1:length(k)){
    yhat<-knn(x.train,x.test,cl=y.train,k=k[j])
    err.cv[i,j]<-mean(yhat!=y.test)
  }
}
err.cv
which.min(colMeans(err.cv))

mean.tr<-colMeans(train)
sd.tr<-apply(train,2,sd)
valid.std<-valid
for (j in 1:ncol(valid)) 
  valid.std[,j]<-(valid[,j]-mean.tr[j])/sd.tr[j]
yhat.valid<-knn(train.std,valid.std,ytrain,k=11)
table(yhat.valid,SAheart$chd[-index])
mean(yhat.valid!=SAheart$chd[-index])

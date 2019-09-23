library(rpart)
library(randomForest)
library(kernlab)
library(nnet)

prepareData <- function() {
  x<-cbind(rnorm(10,mean=2,sd=1),rnorm(10,mean=2,sd=1))
  x<-rbind(x,cbind(rnorm(10,mean=2,sd=1),rnorm(10,mean=-2,sd=1)))

  y<-cbind(rnorm(10,mean=-1,sd=1),rnorm(10,mean=0,sd=1))
  y<-rbind(y,cbind(rnorm(10,mean=0,sd=1),rnorm(10,mean=5,sd=1)))
  label <- as.factor(c(rep("A",20),rep("B",20)))
  data.frame(X=rbind(x,y),label=label)
}

displayData <- function(model,data,cex) {
  testval <- seq(-7,7,0.1)
  i <- 1
  n <- length(testval)
  xcoord <- rep(testval,each=n)
  ycoord <- rep(testval,n)
  testdata <- data.frame(X.1=xcoord,X.2=ycoord)
  pred <- predict(model,testdata)
  if (any(class(model)=="nnet")) {
    col <- as.integer(pred+0.49)+1
  }
  else if (class(pred) == "factor") {
    col <- as.integer(pred)
  }
  else if (class(pred) == "matrix") {
    col <- apply(pred,1,which.max)
  }
  plot(xcoord,ycoord,col=col,cex=cex)

  points(data[,1:2],col=as.integer(data[,3]),pch=16)
}

dtdemo <- function(control=list(minsplit=3),cex=0.3) {
  data <- prepareData()
  rp <- rpart(label~.,data=data,method="class",control=control)
  displayData(rp,data,cex) 
}

#dtdemo(0.3,list(minsplit=3,cp=0,xval=2))

rfdemo <- function(ntree=5,cex=0.3) {
  data <- prepareData()
  rf <- randomForest(label~.,data=data,ntree=ntree)
  displayData(rf,data,cex)
}

svmdemo <- function(kernel="rbfdot",kpar=list(sigma=1),cex=0.3) {
  data <- prepareData()
  svm <- ksvm(label~.,data,kernel=kernel,kpar=kpar)
  displayData(svm,data,cex)
}

lindemo <- function(cex=0.3) {
  svmdemo("vanilladot",list(),cex=cex)
}

nndemo <- function(size=c(3),cex=0.3) {
  data <- prepareData()
  data$label <- as.integer(data$label)-1
  nn <- nnet(label~.,data,size=size)
  data$label <- data$label+1
  displayData(nn,data,cex)
}




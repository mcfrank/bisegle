library(gtools)
library(psych)
###### NOW START CODE ######
e1 <- read.csv("~/R/bisegle/data/fggt_data1.csv")
e2 <- read.csv("~/R/bisegle/data/fggt_data2.csv")
d2 <- e2# merge(e1,e2,all=TRUE)

source("~/R/bisegle/helper.R")
d2 <- remove.repeats(d2)

num.samps <- 100
m <- length(d2$WorkerId)
n <- 10
ps <- matrix(nrow=m, ncol=n)
rs <- matrix(nrow=m, ncol=n)
fs <- matrix(nrow=m, ncol=n)
rand.ps <- array(dim=c(m,n,num.samps))
rand.rs <- array(dim=c(m,n,num.samps))
rand.fs <- array(dim=c(m,n,num.samps))

## for each worker
for (s in 1:length(d2$WorkerId)) {
  lang <- d2$Answer.lang[s]
  
  for (i in 1:10) {
    resp <- eval(parse(text=paste("d2$Answer.answer",
                         as.character(i),"[",as.character(s),"]",sep="")))
    corr <- eval(parse(text=paste("d2$Input.correct",
                         as.character(i),"[",as.character(lang),"]",sep="")))
   	vals <- calcft(resp,corr)
    
    ps[s,i] <- vals$p
    rs[s,i] <- vals$r
    fs[s,i] <- vals$f

    ## now bootstrap a new sample
    for (j in 1:num.samps) {
      randresp <- randperm(resp)
      vals <- calcft(randresp,corr)
      rand.ps[s,i,j] <- vals$p
      rand.rs[s,i,j] <- vals$r
      rand.fs[s,i,j] <- vals$f
    }
  }
}

bysub <- data.frame(rowMeans(ps,na.rm=TRUE))
names(bysub) <- "precision"
bysub$recall <- rowMeans(rs,na.rm=TRUE)
bysub$"f score" <- rowMeans(fs,na.rm=TRUE)
#
#pdf("first turk fggt seg pilot.pdf")
#stripchart(bysub,vertical=TRUE,method="stack",offset=.5,pch=20,
#           xlab="measure",ylim=c(0,1))
means <- colMeans(as.matrix(bysub),na.rm=TRUE)
#points(1.1:3.1,means,col="red",pch="-",cex=3)


rand.means <- c(mean(rowMeans(rand.ps,na.rm=TRUE),na.rm=TRUE),
                mean(rowMeans(rand.rs,na.rm=TRUE),na.rm=TRUE),
                mean(rowMeans(rand.fs,na.rm=TRUE),na.rm=TRUE))

rand.cis <- cbind(rowMeans(apply(apply(rand.ps,c(1,3),namean),1,ci)),
                  rowMeans(apply(apply(rand.rs,c(1,3),namean),1,ci)),
                  rowMeans(apply(apply(rand.fs,c(1,3),namean),1,ci)))
#plotCI(1.1:3.1,rand.means,rand.cis[2,] - rand.means,
#       rand.means - rand.cis[1,],col="blue",pch="-",cex=3,add=TRUE)
#legend(2.75,.15,c("participant mean","random baseline"),
#       pch="-",col=c("red","blue"),pt.cex=3) 
#dev.off()
#

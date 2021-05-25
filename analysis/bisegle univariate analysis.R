library(psych)

rm(list=ls())
source("~/R/bisegle/prf functions.R")
source("~/R/bisegle/remove.repeats.R")
source("~/R/bisegle/helper.R")

d1 <- read.csv("~/R/bisegle/data/bisegle_turk_1.11.10.csv",colClasses = "character")
d2 <- read.csv("~/R/bisegle/data/bisegle_turk_1.11.10-2.csv",colClasses = "character")
d3 <- read.csv("~/R/bisegle/data/bisegle_turk_1.14.10.csv",colClasses = "character")
ds <- merge(d2,d3,all=TRUE)
d <- merge(d1,ds,all=TRUE)
d <- remove.repeats(d)
data <- d.to.data(d)
resps <- t(apply(as.array(data$resp),1,convert.to.mat))
data$two.rs = apply(resps,1,two.recall)
data$two.ps = apply(resps,1,two.precision)
data$three.rs = apply(resps,1,three.recall)
data$three.ps = apply(resps,1,three.precision)
data$two.f = apply(data[,3:4],1,harmonic.mean)
data$three.f = apply(data[,5:6],1,harmonic.mean)

twof = by(data$two.f,data$subnum,mean)
threef = by(data$three.f,data$subnum,mean)

# now get baselines
num.samps <- 100
n <- nrow(resps)
rand.2fs <- array(dim=c(n,num.samps))
rand.3fs <- array(dim=c(n,num.samps))

## for each worker
for (s in 1:n) {
  for (j in 1:num.samps) {
    randresp <- randperm.n(as.numeric(resps[s,]))
    rand.3fs[s,j] <- harmonic.mean(c(three.precision(randresp),three.recall(randresp)))
    rand.2fs[s,j] <- harmonic.mean(c(two.precision(randresp),two.recall(randresp)))
  }
}

rand3 <- rowMeans(rand.3fs)
rand2 <- rowMeans(rand.2fs)
rand2.sub <- by(rand2,data$subnum,mean)
rand3.sub <- by(rand3,data$subnum,mean)



bysub <- data.frame(rowMeans(ps,na.rm=TRUE))
names(bysub) <- "precision"
bysub$recall <- rowMeans(rs,na.rm=TRUE)
bysub$"f score" <- rowMeans(fs,na.rm=TRUE)

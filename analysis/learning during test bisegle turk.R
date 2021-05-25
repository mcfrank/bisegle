
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

data$two.rs = apply(resps,1,two.b.recall)
data$two.ps = apply(resps,1,two.b.precision)
data$three.rs = apply(resps,1,three.b.recall)
data$three.ps = apply(resps,1,three.b.precision)
data$two.f = apply(data[,3:4],1,harmonic.mean)
data$three.f = apply(data[,5:6],1,harmonic.mean)


sent = rep(1:10,118)

layout(matrix(seq(1,10,1), 2, 5, byrow = TRUE))
cols = col=gray(seq(0,1,1/12))

kde = list()
for (i in 1:10) {
	x = by(data$two.f[sent==i],data$subnum[sent==i],mean)
	
	y = by(data$three.f[sent==i],data$subnum[sent==i],mean)
	
	kde[[i]] = kde2d(x,y,lims=c(c(0,1),c(0,1)))
	image(1-kde[[i]]$z,col=cols)
#	plot(x,y,xlim=c(0,1),ylim=c(0,1))
}

kl = matrix(ncol=10,nrow=10)
for (i in 1:10) {
	for (j in 1:10) {
		show(i)
		show(j)
		kl[i,j] = kldiv(kde[[i]]$z,kde[[j]]$z)		
	}
}

### FIRST HALF VS LAST HALF
first2 = by(data$two.f[sent<6],data$subnum[sent<6],mean)
first3 = by(data$three.f[sent<6],data$subnum[sent<6],mean)
second2 = by(data$two.f[sent>6],data$subnum[sent>6],mean)
second3 = by(data$three.f[sent>6],data$subnum[sent>6],mean)
first = kde2d(first2,first3,lims=c(c(0,1),c(0,1)))
second = kde2d(second2,second3,lims=c(c(0,1),c(0,1)))

image(1-first$z)
image(1-second$z)
kldiv(first$z,second$z)

# resampling
dist <- c()
for (i in 1:100) {
	
	
	first2 = by(data$two.f[sent<6],data$subnum[sent<6],mean)
	first3 = by(data$three.f[sent<6],data$subnum[sent<6],mean)
	second2 = by(data$two.f[sent>6],data$subnum[sent>6],mean)
	second3 = by(data$three.f[sent>6],data$subnum[sent>6],mean)
	first = kde2d(first2,first3,lims=c(c(0,1),c(0,1)))
	second = kde2d(second2,second3,lims=c(c(0,1),c(0,1)))

	dist[i] <- kldiv(first$z,second$z)
}


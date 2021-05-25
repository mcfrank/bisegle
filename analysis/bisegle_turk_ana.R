library(psych)
library(MASS)
library(gtools)

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

data$two.b.rs = apply(resps,1,two.b.recall)
data$two.b.ps = apply(resps,1,two.b.precision)
data$three.b.rs = apply(resps,1,three.b.recall)
data$three.b.ps = apply(resps,1,three.b.precision)
data$two.b.f = apply(data[,3:4],1,harmonic.mean)
data$three.b.f = apply(data[,5:6],1,harmonic.mean)
data$two.t.rs = apply(resps,1,two.t.recall)
data$two.t.ps = apply(resps,1,two.t.precision)
data$three.t.rs = apply(resps,1,three.t.recall)
data$three.t.ps = apply(resps,1,three.t.precision)
data$two.t.f = apply(data[,9:10],1,harmonic.mean)
data$three.t.f = apply(data[,11:12],1,harmonic.mean)

# initialize all the variables
m.temp <- list()
m.twof.b <- list()
m.threef.b <- list()
m.twof.t <- list()
m.threef.t <- list()
m.twof.b[[1]] = as.numeric(by(data$two.b.f,data$subnum,mean))
m.threef.b[[1]] = as.numeric(by(data$three.b.f,data$subnum,mean))
m.twof.t[[1]] = as.numeric(by(data$two.t.f,data$subnum,mean))
m.threef.t[[1]] = as.numeric(by(data$three.t.f,data$subnum,mean))

#### RESPONSES PLOT ####
pdf("~/Desktop/bisegle tex/figures/responses.pdf",width=6.8,height=2)
layout(matrix(seq(1,24,1), 3, 8, byrow = TRUE))

inds <- order(m.twof.b[[1]])
props <- m.twof.b[[1]][inds]
inds <- inds[seq(1,length(props),round(length(props)/24))]
props <- props[seq(1,length(props),round(length(props)/24))]
inds[1:2] <- inds[2:1]
for (i in 1:24) {
	par(mar=c(1,1,1,1)) # bottom, left, top, right
	plot(1:11,colMeans(resps[(((inds[i]-1)*10) + 1):(inds[i]*10),]),type="l",ylab="",
		yaxt="n",xaxt="n",ylim=c(0,1))
}
dev.off()


## now get baselines
num.samps <- 1
n <- nrow(resps)
rand.b.2fs <- array(dim=c(n,num.samps))
rand.b.3fs <- array(dim=c(n,num.samps))
rand.t.2fs <- array(dim=c(n,num.samps))
rand.t.3fs <- array(dim=c(n,num.samps))

## for each worker
for (s in 1:n) {
  for (j in 1:num.samps) {
    randresp <- randperm.n(as.numeric(resps[s,]))
    rand.b.3fs[s,j] <- harmonic.mean(c(three.b.precision(randresp),three.b.recall(randresp)))
    rand.b.2fs[s,j] <- harmonic.mean(c(two.b.precision(randresp),two.b.recall(randresp)))
    rand.t.3fs[s,j] <- harmonic.mean(c(three.t.precision(randresp),three.t.recall(randresp)))
    rand.t.2fs[s,j] <- harmonic.mean(c(two.t.precision(randresp),two.t.recall(randresp)))
  }
}

m.twof.b[[3]] <- as.numeric(by(rand.b.2fs,data$subnum,mean))
m.threef.b[[3]] <- as.numeric(by(rand.b.3fs,data$subnum,mean))
m.twof.t[[3]] <- as.numeric(by(rand.t.2fs,data$subnum,mean))
m.threef.t[[3]] <- as.numeric(by(rand.t.3fs,data$subnum,mean))
#m.temp[[1]] <- rep(1,length(m.twof.b[[1]]))
#m.temp[[2]] <- rep(1,length(m.twof.b[[2]]))

source("~/R/bisegle/readEmpiricalBaseline.R")


### BIG LOAD LOOP ###
model.files <- c("ggj-2-online.csv","ggj-3-online.csv","tps-0.csv") #"bisegle_4.16.09_nonan.csv",
for (i in 4:(length(model.files)+3)) {
	show(paste("loading",i))

	# models
	if (i > 1) {mdata <- read.csv(paste("~/R/bisegle/data/",model.files[i-3],sep=""))
		two.b.rs = apply(mdata[,4:14],1,two.b.recall)
		two.b.ps = apply(mdata[,4:14],1,two.b.precision)
		three.b.rs = apply(mdata[,4:14],1,three.b.recall)
		three.b.ps = apply(mdata[,4:14],1,three.b.precision)
		two.b.f = apply(cbind(two.b.ps,two.b.rs),1,na.harmonic.mean)
		three.b.f = apply(cbind(three.b.ps,three.b.rs),1,na.harmonic.mean)
		two.t.rs = apply(mdata[,4:14],1,two.t.recall)
		two.t.ps = apply(mdata[,4:14],1,two.t.precision)
		three.t.rs = apply(mdata[,4:14],1,three.t.recall)
		three.t.ps = apply(mdata[,4:14],1,three.t.precision)
		two.t.f = apply(cbind(two.t.ps,two.t.rs),1,na.harmonic.mean)
		three.t.f = apply(cbind(three.t.ps,three.t.rs),1,na.harmonic.mean)

		m.twof.b[[i]] = as.numeric(by(two.b.f,mdata$subject,mean))
		m.threef.b[[i]] = as.numeric(by(three.b.f,mdata$subject,mean))
		m.twof.t[[i]] = as.numeric(by(two.t.f,mdata$subject,mean))
		m.threef.t[[i]] = as.numeric(by(three.t.f,mdata$subject,mean))
		m.temp[[i]] = as.numeric(by(mdata[,3],mdata$subject,mean))
	}
}

####### SCATTER PLOT ####
cols = c("red","blue","green")
rainbows = rainbow(10)
t.names = c("Human data","Test-only condition","Random baseline",
	"Bayesian Lexical Model","Unused","Transition Probability")

pdf("~/Desktop/bisegle tex/figures/token_f.pdf",width=6.8,height=5)
layout(matrix(c(1,1,2,2,3,3,0,4,4,5,5,0), 2, 6, byrow = TRUE))

for (i in c(1,2,3,4,6)) {
	x = m.twof.t[[i]]
	y = m.threef.t[[i]]
	ok = x > 0 | y | 0
	plot(x[ok],y[ok],
		xlab="F-score for two-segmentation",ylab="F-score for three-segmentation",
		pch=20,bty="n",xlim=c(0,1),ylim=c(0,1),xpd="n",xaxp=c(0,1,2),yaxp=c(0,1,2),col="black")
		#col=rainbows[m.temp[[i]]])
	title(t.names[i])
}
dev.off()

pdf("~/Desktop/bisegle tex/figures/boundary_f.pdf",width=6.8,height=5)
layout(matrix(c(1,1,2,2,3,3,0,4,4,5,5,0), 2, 6, byrow = TRUE))

for (i in c(1,2,3,4,6)) {
	plot(m.twof.b[[i]],m.threef.b[[i]],
		xlab="F-score for two-segmentation",ylab="F-score for three-segmentation",
		pch=20,bty="n",xlim=c(0,1),ylim=c(0,1),xpd="n",xaxp=c(0,1,2),yaxp=c(0,1,2),col="black")
		#col=rainbows[m.temp[[i]]])
	title(t.names[i])
}
dev.off()

### DO DIVERGENCES ####
kls = matrix(nrow=6,ncol=2)
dists = matrix(nrow=6,ncol=2)
measures = c("b","t")
cols = col=gray(seq(0,1,1/12))
kde <- list()
layout(matrix(seq(1,12,1), 2, 6, byrow = TRUE))
for (i in 1:2) {	
	for (j in 1:6) {
		x <- eval(parse(text=paste("m.twof.",measures[i],"[[j]]",sep="")))
		y <- eval(parse(text=paste("m.threef.",measures[i],"[[j]]",sep="")))
		ok = x > 0 | y > 0
		x = x[ok]
		y = y[ok]
		kde[[j]] <- kde2d(x,y,c(.2,.2),lims=c(c(0,1),c(0,1)))
		kls[j,i] = kldiv(kde[[1]]$z,kde[[j]]$z)
		z <- kde[[j]]$z / sum(kde[[j]]$z)
		image(1 - z,col=cols)
		title(t.names[j])
		z1 <- kde[[1]]$z / sum(kde[[1]]$z)
#		dists[j,i] = mean((z > .001) == (z1 > .001))

	}
}



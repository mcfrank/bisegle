d <- read.csv("~/R/bisegle/data/empirical_baseline.csv",colClasses = "character")
d <- remove.repeats(d)
data <- d.to.data(d)
resps <- t(apply(as.array(data$resp),1,convert.to.mat))

resps <- resps[seq(1,nrow(resps),10),]


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


m.twof.b[[2]] = as.numeric(by(data$two.b.f,data$subnum,mean))
m.threef.b[[2]] = as.numeric(by(data$three.b.f,data$subnum,mean))
m.twof.t[[2]] = as.numeric(by(data$two.t.f,data$subnum,mean))
m.threef.t[[2]] = as.numeric(by(data$three.t.f,data$subnum,mean))
m.twof.b[[2]] <- m.twof.b[[2]][!is.na(m.twof.b[[2]])]
m.twof.t[[2]] <- m.twof.t[[2]][!is.na(m.twof.t[[2]])]
m.threef.b[[2]] <- m.threef.b[[2]][!is.na(m.threef.b[[2]])]
m.threef.t[[2]] <- m.threef.t[[2]][!is.na(m.threef.t[[2]])]
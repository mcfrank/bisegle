convert.to.mat <- function(x) {
	y <- c()
	for (i in 1:11) {
		y[i] <- as.numeric(substr(x,i,i))
	}	
	return(y)
}

two.b.precision <- function(x) {
	hits <- sum(x[c(2,4,6,8,10)]==1)
	fas <- sum(x[c(1,3,5,7,9,11)]==1) 
	return(hits / (hits + fas))
}

two.b.recall <- function(x) {
	hits <- sum(x[c(2,4,6,8,10)]==1)
	misses <- sum(x[c(2,4,6,8,10)]==0) 
	return(hits / (hits + misses))
}

three.b.precision <- function(x) {
	hits <- sum(x[c(3,6,9)]==1)
	fas <- sum(x[c(1,2,4,5,7,8,10,11)]==1) 
	return(hits / (hits + fas))
}

three.b.recall <- function(x) {
	hits <- sum(x[c(3,6,9)]==1)
	misses <- sum(x[c(3,6,9)]==0) 
	return(hits / (hits + misses))
}

two.t.recall <- function(x) {
	if(length(x) != 11) return(NA)
	if(NA %in% x || NaN %in% x) return(NA)
	count = 0
	if(all(x[1:2] == c(0, 1))) count = count + 1
	for(i in seq(2, 8, 2)) {
		if(all(x[i:(i+2)] == c(1, 0, 1))) count = count + 1
		}
	if(all(x[10:11] == c(1, 0))) count = count + 1
	return(count/6)
	}


three.t.recall <- function(x) {
	if(length(x) != 11) return(NA)
	if(NA %in% x || NaN %in% x) return(NA)
	count = 0
	if(all(x[1:3] == c(0, 0, 1))) count = count + 1
	for(i in c(3, 6)) {
		if(all(x[i:(i+3)] == c(1, 0, 0, 1))) count = count + 1
		}
	if(all(x[9:11] == c(1, 0, 0))) count = count + 1
	return(count/4)
	}

two.t.precision <- function(x) {
	if(length(x) != 11) return(NA)
	if(NA %in% x || NaN %in% x) return(NA)
	count = 0
	if(all(x[1:2] == c(0, 1))) count = count + 1
	for(i in seq(2, 8, 2)) {
		if(all(x[i:(i+2)] == c(1, 0, 1))) count = count + 1
		}
	if(all(x[10:11] == c(1, 0))) count = count + 1
	return(count/(sum(x)+1))
	}


three.t.precision <- function(x) {
	if(length(x) != 11) return(NA)
	if(NA %in% x || NaN %in% x) return(NA)
	count = 0
	if(all(x[1:3] == c(0, 0, 1))) count = count + 1
	for(i in c(3, 6)) {
		if(all(x[i:(i+3)] == c(1, 0, 0, 1))) count = count + 1
		}
	if(all(x[9:11] == c(1, 0, 0))) count = count + 1
	return(count/(sum(x)+1))
	}
	
library(psych)
na.harmonic.mean <- function(x) {
	y <- harmonic.mean(x,na.rm=TRUE)
	return(y)	
}

kldiv <- function(x,y,eps=1e-04) {
	x = x + eps
	y = y + eps
	
	x = x / sum(x) 
	y = y / sum(y)
	
	kl = sum(x * (log2(x) - log2(y)))	
	return(kl)
}
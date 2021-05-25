## NAMEAN
namean <- function(x) {mean(x,na.rm=TRUE)}

## CI
ci <- function(x) {quantile(x,c(.025,.975))}

## RANDPERM - permutes elements in a response
randperm <- function(x) {
  x <- as.character(x)
  n <- nchar(x)
  ord <- permute(1:n)

  newstr <- ""
  for (i in 1:n) {
    newstr <- paste(newstr,substr(x,ord[i],ord[i]),sep="")
  }

  return(newstr)
}

randperm.n <- function(x) {
  n <- length(x)
  ord <- permute(1:n)

  newstr <- c()
  for (i in 1:n) {
    newstr[i] <- x[ord[i]]
  }

  return(newstr)
}

## CALCF - gives you prf scores for a response relative to correct answer
calcf <- function(x,y) {
  ans <- as.character(x[1])
  cor <- as.character(y[1])

  hits = 0
  misses = 0
  fas = 0

  # compute actual scores
  for (i in 1:nchar(ans)) {
    if (substr(ans,i,i) == "1" & substr(cor,i,i) == "1") {hits <- hits + 1}
    if (substr(ans,i,i) == "1" & substr(cor,i,i) == "0") {misses <- misses + 1}
    if (substr(ans,i,i) == "0" & substr(cor,i,i) == "1") {fas <- fas + 1}
  }

  p <- hits / (hits + misses)
  r <- hits / (hits + fas)
  f <- harmonic.mean(c(p,r))

  vals <- list()
  vals$p <- p
  vals$r <- r
  vals$f <- f
  return(vals)
}

## CALCFT - gives you prf scores for a response relative to correct answer for tokens

calcft <- function(x,y) {
  ans <- as.character(x[1])
  cor <- as.character(y[1])
  
  while (nchar(ans) < 11) {
  	ans <- paste("0",ans,sep="")
  }

  while (nchar(cor) < 11) {
  	cor <- paste("0",cor,sep="")
  }

	segs <- 0
	for (i in 1:nchar(ans)) {
		if (substr(ans,i,i) == "1") {segs <- segs + 1}
	}
		
	hits = 0	

  # compute actual scores
  c = 1
  for (i in 1:4) {
  	hit = 1
  	word = 1
  	while (word == 1) {
  		if (substr(ans,c,c) != substr(cor,c,c)) {hit = 0}
  		if (substr(cor,c,c) == "1" | c > 11) {word = 0} 
  		c = c + 1
  	}
  	
  	hits = hits + hit
  }

	misses = 4 - hits
	fas = (segs + 1) - hits

  p <- hits / (hits + misses)
  r <- hits / (hits + fas)
  f <- harmonic.mean(c(p,r))

  vals <- list()
  vals$p <- p
  vals$r <- r
  vals$f <- f
  return(vals)
}

## @knitr lin-reg-cost-func
computeCost <- function(X, y, theta, lambda = 0){
    if(is.null(dim(X))){
        X <- t(data.frame(X))
    }

    m <- nrow(X)
    pred <- theta %*% t(X)
    sqError <- (pred - y) ^ 2
    cost <- (1 / (2 * m)) * sum(sqError)
    reg <- (lambda / (2 * m)) * sum(theta[-1]^2)
    J <- cost + reg

    gradient <- (1 / m) * sum((pred - y) * X[, 1]) # first element unregularized
    for(j in 2:length(theta)){
        gradient <- c(gradient, ((1 / m) * sum((pred - y) * X[, j]) + lambda * theta[j] / m))
    }
    return(list(J=J, gradient=gradient))
}

## @knitr gradStep
gradStep <- function(thetaj, alpha, gradj){
    thetaj - alpha * gradj
}

## @knitr gradientDescent
gradientDescent <- function(X, y, theta, alpha, iterations, lambda = 0){
    if(length(theta) != ncol(X)){stop("theta and X are nonconformable")}
    J_history <- data.frame()
    for (iteration in 1:iterations){

        a <- computeCost(X = X, y = y, theta = theta, lambda = lambda)
        J <- a$J
        gradient <- a$gradient
        J_history <- rbind(J_history, c(J, iteration - 1, theta))

        thetaTemp <- vector()
        for(j in 1:length(theta)){
            thetaTemp <- c(thetaTemp, gradStep(theta[j], alpha, gradient[j]))
        }
        theta <- thetaTemp
    }
    # for final iteration
    J <- computeCost(X = X, y = y, theta = theta, lambda = lambda)$J
    J_history <- rbind(J_history, c(J, iteration, theta))
    thetanames <- rep("theta", times = length(theta) - 1)
    for(i in length(thetanames)){thetanames[i] <- paste("theta", i, sep = "")}
    colnames(J_history) <- c("loss", "iterations", "theta0", thetanames)
    return(J_history)
}

## @knitr featureNormalize
featureNormalize <- function(X){
    apply(X, 2, FUN = function(x){(x - mean(x)) / sd(x)})
}
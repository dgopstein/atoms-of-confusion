tplot <- function(x, ...) UseMethod("tplot")

tplot.default <- function(x, ..., type="d", dist=NULL, jit=NULL, names, xlim=NULL, ylim=NULL, main=NULL,
                          sub=NULL, xlab=NULL, ylab=NULL, col=NULL, group.col=FALSE, boxcol=NULL,
                          boxborder=NULL, pch=par("pch"), group.pch=FALSE, median.line=FALSE,
                          mean.line=FALSE, median.pars=list(col=par("col")), mean.pars=median.pars,
                          boxplot.pars=NULL, show.n=FALSE, cex.n=NULL, my.gray=gray(0.75), ann=par("ann"),
                          axes=TRUE, frame.plot=axes, add=FALSE, at=NULL, horizontal=FALSE, panel.first=NULL,
                          panel.last=NULL) {

	## Version 3.2.1	6/17/14

    localPoints <- function(..., tick) points(...)
    localAxis <- function(..., bg, cex, lty, lwd) axis(...)
    localBox <- function(..., bg, cex, lty, lwd, tick) box(...)
    localWindow <- function(..., bg, cex, lty, lwd, tick) plot.window(...)
    localTitle <- function(..., bg, cex, lty, lwd, tick) title(...)
    localMtext <- function(..., bg, cex, lty, lwd, tick) mtext(..., cex=cex.n)

    args <- list(x, ...)
    namedargs <- if (!is.null(attributes(args)$names)){
        attributes(args)$names != ""} else {
            logical(length(args))
    }

    groups <- if (is.list(x)){
        x} else {
            args[!namedargs]
    }

    pars <- args[namedargs]
    
    if ((n <- length(groups)) == 0){ stop("invalid first argument") }
    if (length(class(groups))){ groups <- unclass(groups) }
    if (!missing(names)){ attr(groups, "names") <- names } else {
        if (is.null(attr(groups, "names")))
            attr(groups, "names") <- 1:n
        names <- attr(groups, "names")
    }

    ng <- length(groups) # number of groups
    l <- sapply(groups, length) # size of each group
    g <- factor(rep(1:ng, l), levels=1:ng, labels=names(groups)) # groups as.numeric
    nv <- sum(l) # total count

    if (is.null(at)) at <- 1:ng
    if (length(at) != ng)
        stop("'at' must have same length as the number of groups")

    # set y scale
    if (is.null(ylim)) {
        r <- range(groups, na.rm=TRUE, finite=TRUE)
        pm <- diff(r) / 20
        ylim <- r + pm * c(-1,1)
    }
    # set x scale
    if (is.null(xlim)) {
        if (is.null(at)) xlim <- c(0.5, ng+0.5)
        else xlim <- c(0.5, max(at)+0.5)
    }

    if (is.null(xlab)) xlab <- ""
    if (is.null(ylab)) ylab <- ""
    if (is.null(main)) main <- ""
    if (is.null(sub)) sub <- ""

    type <- match.arg(type, choices=c("d","db","bd","b"), several.ok=TRUE)
    # type of plot for each group
    # if ((length(type) > 1) && (length(type) != ng))
    #    warning("length of 'type' does not match the number of groups")
    type <- rep(type, length.out=ng)
    #type[l > 1000] <- "b"

    # Handle default colors
    defcols <- c(my.gray, par("col"))
    # use 50% gray for box in back, otherwise default color
    if (is.null(boxborder)){ boxborder <- defcols[2-grepl(".b", type)] }
    boxborder <- rep(boxborder, length.out=ng)
    # use 50% gray for dots in back, otherwise default color
    if (is.null(col)) {
        col <- defcols[2-grepl(".d", type)]
        group.col <- TRUE
    }

    if(!is.null(boxcol)) boxcol <- rep(boxcol, length.out=ng)
    if( is.null(boxcol)) boxcol <- rep(0,      length.out=ng)

    # Use colors by group
    if (group.col) {
         # if (length(col) != ng)
          #  warning("length of 'col' does not match the number of groups")
        g.col <- rep(col, length.out=ng)
        col <- rep(g.col, l)
    # Use colors by individual or global
    } else {
       # if((length(col) > 1) && (length(col) != nv))
       #      warning("length of 'col' does not match the number of data points")
        col <- rep(col, length.out=nv)
        g.col <- rep(1, length.out=ng)
    }

    # Use plot characters by group
    if (group.pch) {
        # if (length(pch) != ng)
         #   warning("length of 'pch' does not match the number of groups")
        pch <- rep(rep(pch, length.out=ng), l)
    # Use plot characters by individual or global
    } else {
       # if((length(pch) > 1) && (length(pch) != nv))
       #     warning("length of 'pch' does not match the number of data points")
        pch <- rep(pch, length.out=nv)
    }

    # split colors and plot characters into groups
    col <- split(col, g)
    pch <- split(pch, g)
    # remove any NAs from the data and options
    nonas <- lapply(groups, function(x) !is.na(x))
    groups <- mapply("[", groups, nonas, SIMPLIFY=FALSE)
    l <- sapply(groups, length)
    col <- mapply("[", col, nonas, SIMPLIFY=FALSE)
    pch <- mapply("[", pch, nonas, SIMPLIFY=FALSE)

    # whether or not to display a mean and median line for each group
    mean.line <- rep(mean.line, length.out=ng)
    median.line <- rep(median.line, length.out=ng)

    # set defaults for dist and jit
    if (is.null(dist) || is.na(dist)) dist <- diff(range(ylim)) / 100
    if (is.null(jit) || is.na(jit)) jit <- 0.025 * ng

    # 1 2 3 1 3 2 1 1 4 2
    # -------------------
    # 1 1 1 2 2 2 3 4 1 3
    how.many.so.far <- function(g) {
        out <- NULL
        u <- unique(g)
        for (i in 1:length(u)) {
            j <- g == u[i]
            out[which(j)] <- 1:sum(j)
        }
        out
    }
    how.many.so.far2 <- function(g) {
        ## This is slower than how.many.so.far() above...
        rank(g, ties='first') - rank(g, ties='min') + 1
    }

    # turns the values in each group into their plotting points
    grouping <- function(v, dif) {
        vs <- sort(v)
        together <- c(FALSE, diff(vs) <= dif)
        g.id <- cumsum(!together)
        g.si <- rep(x<-as.vector(table(g.id)), x)
        vg <- cbind(vs, g.id, g.si)[rank(v),]
        if (length(v)==1) vg <- as.data.frame(t(vg))
        hmsf <- how.many.so.far(vg[,2])
        data.frame(vg, hmsf)
    }
    groups <- lapply(groups, grouping, dif=dist)

    # set up new plot unless adding to existing one
    if (!add) {
        plot.new()
        if (horizontal)
            do.call("localWindow", c(list(ylim, xlim), pars))
        else
            do.call("localWindow", c(list(xlim, ylim), pars))
    }
    panel.first

    # function to compute the jittering
    jit.f2 <- function(g.si, hm.sf) { hm.sf - (g.si + 1) / 2 }

    out <- list()

    Lme <- 0.2 * c(-1, 1)
    for (i in 1:ng) {
        to.plot <- groups[[i]]
        gs <- to.plot$g.si
        hms <- to.plot$hmsf
        x <- rep(at[i], nrow(to.plot)) + jit.f2(gs, hms) * jit
        y <- to.plot$vs

        if (type[i] == "bd") { # dots behind
            boxplotout <- do.call('boxplot', c(list(x=y, at=at[i], plot=FALSE, add=FALSE, axes=FALSE, col=boxcol[i], border=boxborder[i], outline=FALSE, horizontal=horizontal), boxplot.pars))
            notoplot <- (y <= boxplotout$stats[5,]) & (y >= boxplotout$stats[1,])
            if( sum(notoplot) > 0 ){ col[[i]][notoplot] <- '#BFBFBF' }
            if (horizontal)
                do.call("localPoints", c(list(x=y, y=x, pch=pch[[i]], col=col[[i]]), pars))
            else
                do.call("localPoints", c(list(x=x, y=y, pch=pch[[i]], col=col[[i]]), pars))
        }
        if (type[i] %in% c("bd", "b")) { # boxplot in front
            boxplotout <- do.call("boxplot", c(list(x=y, at=at[i], add=TRUE, axes=FALSE, col=boxcol[i], border=boxborder[i], outline=FALSE, horizontal=horizontal), boxplot.pars))
            toplot <- (y > boxplotout$stats[5,]) | (y < boxplotout$stats[1,])
            if( sum(toplot) > 0 ){
            if( col[[i]][toplot][1] == '#BFBFBF' ) col[[i]][toplot] <- 1 }
            if (horizontal)
                do.call("localPoints", c(list(x=y[toplot], y=x[toplot], pch=pch[[i]][toplot], col=col[[i]][toplot]), pars))
            else
                do.call("localPoints", c(list(x=x[toplot], y=y[toplot], pch=pch[[i]][toplot], col=col[[i]][toplot]), pars))
        }
        if (type[i] == "db") # boxplot behind
            do.call("boxplot", c(list(x=y, at=at[i], add=TRUE, axes=FALSE, col=boxcol[i], border=boxborder[i], outline=FALSE, horizontal=horizontal), boxplot.pars))
        if (type[i] %in% c("db", "d")) { # dots in front
            if (horizontal)
                do.call("localPoints", c(list(x=y, y=x, pch=pch[[i]], col=col[[i]]), pars))
            else
                do.call("localPoints", c(list(x=x, y=y, pch=pch[[i]], col=col[[i]]), pars))
        }
        if (mean.line[i]) { # mean line
            if (horizontal)
                do.call("lines", c(list(rep(mean(y), 2), at[i]+Lme), mean.pars))
            else
                do.call("lines", c(list(at[i]+Lme, rep(mean(y), 2)), mean.pars))
        }
        if (median.line[i]) { # median line
            if (horizontal)
                do.call("lines", c(list(rep(median(y), 2), at[i]+Lme), median.pars))
            else
                do.call("lines", c(list(at[i]+Lme, rep(median(y), 2)), median.pars))
        }

        out[[i]] <- data.frame(to.plot, col=col[[i]], pch=pch[[i]])
    }
    panel.last

    # add axes
    if (axes) {
        do.call("localAxis", c(list(side=1+horizontal, at=at, labels=names), pars))
        do.call("localAxis", c(list(side=2-horizontal), pars))
    }
    # optional sample sizes
    if (show.n){
        if(is.null(cex.n)) cex.n <- 1
        do.call("localMtext", c(list(paste("n=", l, sep=""), side=3+horizontal, at=at), pars, list(xaxt='s', yaxt='s')))
        }
    # add bounding box
    if (frame.plot)
        do.call("localBox", pars)
    # add titles
    if (ann) {
        if (horizontal)
            do.call("localTitle", c(list(main=main, sub=sub, xlab=ylab, ylab=xlab), pars))
        else
            do.call("localTitle", c(list(main=main, sub=sub, xlab=xlab, ylab=ylab), pars))
    }

    names(out) <- names(groups)
    invisible(out)
}

tplot.formula <- function(formula, data=parent.frame(), ..., subset) {
    if (missing(formula) || (length(formula) != 3))
        stop("'formula' missing or incorrect")

    enquote <- function(x) { as.call(list(as.name("quote"), x)) }

    m <- match.call(expand.dots = FALSE)
    if (is.matrix(eval(m$data, parent.frame())))
        m$data <- as.data.frame(data)

    args <- lapply(m$..., eval, data, parent.frame())
    nmargs <- names(args)
    if ("main" %in% nmargs) args[["main"]] <- enquote(args[["main"]])
    if ("sub" %in% nmargs) args[["sub"]] <- enquote(args[["sub"]])
    if ("xlab" %in% nmargs) args[["xlab"]] <- enquote(args[["xlab"]])
    if ("ylab" %in% nmargs) args[["ylab"]] <- enquote(args[["ylab"]])

    m$... <- NULL
    m$na.action <- na.pass
    subset.expr <- m$subset
    m$subset <- NULL
    require(stats, quietly=TRUE) || stop("package 'stats' is missing")
    m[[1]] <- as.name("model.frame")
    mf <- eval(m, parent.frame())
    response <- attr(attr(mf, "terms"), "response")

    ## special handling of col and pch
    n <- nrow(mf)
    # pick out these options
    group.col <- if ("group.col" %in% names(args)) args$group.col else FALSE
    group.pch <- if ("group.pch" %in% names(args)) args$group.pch else FALSE
    # reorder if necessary
    if ("col" %in% names(args) && !group.col)
        args$col <- unlist(split(rep(args$col, length.out=n), mf[-response]))
    if ("pch" %in% names(args) && !group.pch)
        args$pch <- unlist(split(rep(args$pch, length.out=n), mf[-response]))

    if (!missing(subset)) {
        s <- eval(subset.expr, data, parent.frame())
        dosub <- function(x) { if (length(x) == n) x[s] else x }
        args <- lapply(args, dosub)
        mf <- mf[s,]
    }
    do.call("tplot", c(list(split(mf[[response]], mf[-response])), args))
}

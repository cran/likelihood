\name{likeli_4_optim}
\alias{likeli_4_optim}
\title{Use Likelihood with Optim}

\description{
  Wraps the function \code{\link{likeli}} so you can use it with
  \code{\link{optim}}.  This allows you to use other optimization methods to
  find maximum likelihood estimates.
}
\usage{
likeli_4_optim(par_2_analyze, model, par_names, var, source_data, pdf)
}
\arguments{
\item{par_2_analyze}{Vector of initial values for those parameters that are
  to be optimized.  This should be a vector, NOT a list.  This MUST be a 
  one-dimensional vector - i.e. none of the vector members can be vectors
  themselves (in contrast to the rules for \code{anneal}).  \code{optim} will
  pass this argument to \code{likeli_4_optim} automatically. See the example
  for more.}
\item{model}{Model function for which to calculate likelihood.}
\item{par_names}{Character vector with the name for each value in
  \code{par_2_analyze}.}
\item{var}{List object with the source for all other non-parameter arguments and
 data used by the model, the PDF, and any sub-functions. This is the same as
 the argument that you pass to \code{\link{anneal}} or \code{\link{likeli}}.}
\item{source_data}{Data frame containing any needed source data, including
  observed values.}
\item{pdf}{Probability density function to use.  If you want a log
  likelihood value, which is usual, the PDF must calculate the log of its
  result.}
}

\value{
A single numeric value for the likelihood.  It is possible for this to be 
  \code{NAN} or \code{Inf}.
}

\details{
  This wraps the \code{\link{likeli}} function so that it can conform to the
  requirements of \code{\link{optim}}.  Setting up to use this function is
  exactly like setting up to use \code{likeli}.
  
  Remember to set the \code{fnscale} option in the control list for 
  \code{optim} to -1 so that \code{optim} performs a maximization rather than 
  the default minimization (see example for details).
}

\examples{
#################
## Set up for likeli
#################
## Use the included crown_rad dataset
data(crown_rad)

## Create our model function - crown radius is a linear function of DBH.
## DBH is a column of data from the crown_rad dataset; a and b are single
## parameter values.
model <- function (a, b, DBH) {a + b * DBH}

## We are planning to get maximum likelihood estimates for a and b.  Create
## the list that says where all other functions and data are to be found.
## Indicate that DBH comes from the column marked "DBH" in the crown_rad dataset.
var<-list(DBH = "DBH")

## We'll use the normal probability density function dnorm - add its
## arguments to our parameter list
## "x" value in PDF is observed value
var$x <- "Radius"

## The mean is the predicted value, the outcome of the model statement. Use
## the reserved word "predicted"
var$mean <- "predicted"
var$sd <- 1.0

## Have dnorm calculate log likelihood
var$log <- TRUE

## Set up a vector with initial values for a and b
par_2_analyze <- c(0.1, 0.1)

## Set up the vector with the names of a and b, so likeli_4_optim knows
## what the values in for_optim are
par_names <- c("a", "b")

## Set your choice of optim controls - pass the other likeli_4_optim arguments
## by name so optim knows they are for likeli_4_optim
## Remember to set the fnscale option of optim to a negative value to perform
## a maximization rather than a minimization

\dontrun{optim(par_2_analyze, likeli_4_optim, method = "Nelder-Mead",
  control = list(fnscale = -1), model = model, par_names = par_names,
  var = var, source_data = crown_rad, pdf = dnorm)}
}


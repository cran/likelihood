\name{likeli}
\alias{likeli}
\title{Calculate Likelihood}

\description{
  Calculate likelihood of a model, given a dataset.  Typically this is
  log likelihood. See the \link{Likelihood Calculation} page for details on how
  likelihood is calculated.
}
\usage{
likeli(model, par, var, source_data, pdf, ...)
}
\arguments{
\item{model}{Model function for which to calculate likelihood.  See details for 
  how to set up this function.}
\item{par}{List object of parameters for which to calculate likelihood. The 
  name of each component in \code{par} matches the name of an argument in one
  of the functions passed to \code{likeli} (either \code{model}, \code{pdf}, or
  another function that does initial calculations). All elements in \code{par}
  must be numeric vectors. This is the same as the argument that you pass to 
  \code{\link{anneal}}.}
\item{var}{List object with the source for all other non-parameter arguments and
  data used by \code{model}, \code{pdf}, and any other functions. This is the 
  same as the argument that you pass to \code{\link{anneal}}.}
\item{source_data}{Data frame containing any needed source data. You can 
  reference the data frame columns by name to \code{likeli}.}
\item{pdf}{Probability density function to use in the likelihood calculation.
  If you want a log likelihood value, which is usual and matches what 
  \code{\link{anneal}} does, instruct \code{pdf} to calculate the log of its 
  result.  This is an option with all of R's built-in PDFs.}
 \item{\dots}{Any other data that may be needed by \code{model}, \code{pdf}, or
  any other function to be called by \code{likeli}.  This is an alternative to 
  providing the data in \code{var}; however, passing values in \code{var} is
  strongly recommended.}
}

\value{
A single numeric value for the likelihood.  It is possible for this to be 
\code{NaN} or \code{Inf}.
}

\details{
  See the \link{Likelihood Calculation} page for details on how
  likelihood is calculated. \code{\link{anneal}} uses the same parameters and
  is set up in the same way.

  The \code{model} function is the scientific model, which generally takes as
  arguments the parameters for which to estimate maximum likelihood.  It 
  returns a predicted value of the dependent variable for each record in the
  \code{source_data} dataset, which is compared to the actual (observed) value
  when likelihood is calculated.  Write \code{model} so that it returns a
  vector of numeric values, one for each record in the dataset.

  The probability density function calculates the likelihood using the
  predicted and observed values of the dependent variable.  You can provide 
  your own function, but R has many built-in functions that you can use. You 
  can read more about R's probability density functions in the help file
  \dQuote{An Introduction to R}, but here is a brief list: \code{\link{dbeta}}
  (beta), \code{\link{dexp}} (exponential), \code{\link{dgamma}} (gamma),
  \code{\link{dlnorm}} (lognormal), \code{\link{dnbinom}} (negative binomial),
  \code{\link{dnorm}} (normal), and \code{\link{dpois}} (poisson).  These all
  take a \code{log} argument which you should set to TRUE in \code{var} in
  order to calculate the log likelihood.  If you write your own probability
  density function, it should return a vector of values, one for each record
  in the dataset.

  If you wish, some of the arguments passed to \code{model} or \code{pdf} by
  \code{likeli} can be the results of other functions.

  \code{likeli} handles all function calls and data.  You tell \code{likeli}
  how to use your functions and data using \code{par} and \code{var}.
  Use \code{par} to give \code{likeli} the list of parameters for the model.
  Use \code{var} to tell \code{likeli} where all other functions and data come
  from.  \code{var} and \code{var} are lists, and each component's name matches
  the function argument it should be used for.  For example, if the 
  \code{model} function takes an argument called \dQuote{\code{a}}, there 
  should be a \code{par$a} or a \code{var$a} with the value of \code{a}.  For
  \code{par}, all values must be numeric vectors.  For \code{var}, the values 
  can be of any data type that makes sense to the function.  To indicate that 
  the source of a function argument is a column of data from a dataset, set 
  that value of \code{var} to the name of the data frame's column, as a 
  character string (for example, \code{var$dbh<-"DBH"}).  Case matters!  You 
  will get the best results if all function arguments and column names are 
  unique, so that there is no ambiguity. You are also free to reference values directly from the global environment in your functions if you prefer.

  The difference between \code{par} and \code{var} is important to
  \code{\link{anneal}} but not to \code{likeli}.

  The reserved character string \dQuote{predicted}, used in \code{var}, means
  the predicted value of the dependent variable, as calculated by \code{model}.

  If you want \code{likeli} to pass the results of another function as an
  argument to the \code{model} or \code{pdf} functions, define the function
  and then set the appropriate argument in \code{var} to the name of the
  function.  Then provide all arguments to the sub-function in \code{var} as
  well.  For instance, if your model function takes an argument called
  \code{x}, and you wish \code{x} to be the result of function \code{fun1},
  then set \code{var$x <- fun1}, and add any arguments to \code{fun1} to
  \code{var}.  \code{likeli} will ensure that all functions are evaluated in
  the proper order.

}

\examples{
library(likelihood)

## Use the included crown_rad dataset
data( crown_rad )

## Create our model function - crown radius is a linear function of DBH.
## DBH is a column of data from the crown_rad dataset; a and b are single
## parameter values.
model <- function (a, b, DBH) {a + b * DBH}

## Create our parameters list and set values for a and b
par <- list(a = 1.12, b = 0.07)

## Create a place to put all the other data needed by
## the model and PDF, and indicate that DBH comes from 
## the column marked "DBH" in the dataset
var <- list(DBH = "DBH")

## We'll use the normal probability density function dnorm - add its
## arguments to our parameter list

## "x" value in PDF is observed value
var$x <- "Radius"

## The mean is the predicted value, the outcome of the model statement. Use
## the reserved word "predicted"
var$mean <- "predicted"
## Use a fixed value of the standard deviation for this example
var$sd <- 0.815585

## Have dnorm calculate log likelihood
var$log <- TRUE

result <- likeli(model, par, var, crown_rad, dnorm)

## Alternately: reference crown_rad$DBH directly in the function without
## using var
model <- function (a, b) {a + b * crown_rad$DBH}
var <- list(x = "Radius",
            mean = "predicted",
            sd = 0.815585,
            log = TRUE)
result <- likeli(model, par, var, crown_rad, dnorm)
}


\name{support_limits}
\alias{support_limits}
\title{Calculate Support Limits}

\description{
  Calculates asymptotic support limits for parameter maximum likelihood estimates. For a parameter, support limits are the values above and below the maximum likelihood estimate that cause the likelihood to drop by a given number of units, while holding all other parameters at their maximum likelihood values. Two units is standard. 1.92 units roughly corresponds to a 95\% confidence interval.
}
\usage{
support_limits(model, par, var, source_data, pdf, par_lo = NULL, 
par_hi = NULL, delta = 100, slimit = 2)
}
\arguments{
\item{model}{Model function for which to calculate likelihood.  This is the
  same as the argument that you pass to \code{\link{anneal}} or
  \code{\link{likeli}}.}
\item{par}{List of parameters for which to find the support limits. The name of
  each component in \code{par} matches the name of an argument in one of the
  functions passed to \code{support_limits} (either \code{model}, \code{pdf},
  or another function that does initial calculations).  The value of each
  component is the maximum likelihood estimate. All components in \code{par}
  must be numeric vectors.  Vectors of length greater than one get a set of
  support limits calculated separately for each vector value. This is the same
  as the argument that you pass to \code{\link{anneal}} or
  \code{\link{likeli}}.}
\item{var}{List object with the source for all other arguments and data used by
  \code{model}, \code{pdf}, and any other functions. This is the same as
 the argument that you pass to \code{\link{anneal}} or \code{\link{likeli}}.}
\item{source_data}{Data frame containing any needed source data. This is the
  same as the argument that you pass to \code{\link{anneal}} or
  \code{\link{likeli}}.}
\item{pdf}{Probability density function to use in likelihood calculations. This
  is the same as the argument that you pass to \code{\link{anneal}} or
  \code{\link{likeli}}.}
\item{par_lo}{List object with lower bounds for the support limit search. The
  support limit bounds are in general the same as the simulated annealing
  search bounds. The list component names and sizes should each match a component in \code{par}. Any individual component (up to and including the entire \code{par_lo} argument) is optional. For any component of \code{par} that is omitted, the lower search bound for that parameter is assumed to be negative infinity. (Infinity isn't quite infinity - see details section for more.) This is the same as the argument that you pass to \code{\link{anneal}}.}
\item{par_hi}{List object with upper bounds for the support limit search. The
  support limit bounds are in general the same as the simulated annealing
  search bounds. The list component names and sizes should each match a component in \code{par}. Any individual component (up to and including the entire \code{par_hi} argument) is optional. For any component of \code{par} that is omitted, the lower search bound for that parameter is assumed to be infinity. (Infinity isn't quite infinity - see details section for more.) This is the same as the argument that you pass to \code{\link{anneal}}.}
\item{delta}{Controls the fineness of the search for support limits.  Each
  parameter is divided by this number to arrive at a step size used for
  \dQuote{walking} the likelihood function.  Bigger numbers mean a finer
  search.  See details for more on how the support limits are determined.}
\item{slimit}{The number of units of likelihood that define the support limits.
  If \code{slimit} is 2, then the limits are those values that cause the 
  likelihood to drop by 2 on either side of the parameter maximum likelihood
  estimate.}
}

\value{
  A list object with two components:  \dQuote{\code{upper_limits}} and
  \dQuote{\code{lower_limits}}.  \code{upper_limits} has the upper support
  limits for each member in \code{par}, with the maximum possible value being
  that parameter's value in \code{par_hi}; \code{lower_limits} has the lower
  support limits, with the minimum possible value being that parameter's value
  in \code{par_lo}.

  If the likelihood calculated from \code{par} is infinite or NA, then the support
  limits will also be NA.
}

\seealso{
  \code{\link{likeli}},
  \code{\link{anneal}}
}

\note{
  The parameter maximum likelihood estimates found by \code{\link{anneal}}
  are in the list component called \code{best_pars}.  These are the values to
  pass to \code{support_limits} for the \code{par} argument.
}

\details{
  Support limits are the values on either side of a parameter's maximum 
  likelihood estimate that make the likelihood drop by \code{slimit} units, 
  holding all other parameters at their maximum likelihood estimate value.  Of
  course, support limits are only meaningful if the values in \code{par} are
  indeed maximum likelihood estimates.  The distance from the maximum 
  likelihood estimate of a parameter to its support limits is an indication of
  the \dQuote{pointiness} of the maximum on the likelihood surface.

  The algorithm produces support limits for a parameter by holding all other
  values at their maximum likelihood value and \dQuote{walking} the likelihood
  function in the plane of that parameter, seeking to find the first spot that
  is \code{slimit} units below the peak likelihood.  It starts by walking in
  big steps, then in progressively smaller steps, until it reaches that point.
  The smallest step it takes is found by dividing the parameter value by
  \code{delta}. This controls the overall fineness of the search.

  The support limits search is bounded by the values in \code{par_lo} and
  \code{par_hi}.  The search uses these bounds to control how it searches.  
  This means that different bounds values may produce slightly different 
  results.  If a bounds value is omitted, \code{support_limits} will attempt 
  an unbounded search, up to infinity.  This will work fine as long as the
  likelihood surface is not completely flat.  In practice, \dQuote{infinity}
  means the largest and smallest values the computer can work with.  To find
  out what the actual limits are on your computer, use
  \code{.Machine$double.xmax}.

  This algorithm works best if the surface produced by the likelihood function
  is continuous and monotonic from the maximum likelihood value out to the
  support limits of all parameters.  This is often not true. However, in most
  cases, this will produce reasonably good results with a low amount of total
  computation time.

  Support limits are calculated automatically at the end of an
  \code{\link{anneal}} run.
}

\examples{
#################
## Set up for an annealing run
#################
## Use the included crown_rad dataset
data(crown_rad)

## Create our model function - crown radius is a linear function of DBH.
## DBH is a column of data from the crown_rad dataset; a and b are single
## parameter values.
model <- function (a, b, DBH) {a + b * DBH}

## Create our parameters list and set values for a and b, and indicate
## that DBH comes from the column marked "DBH" in the crown_rad dataset
par <- list(a = 1.12, b = 0.07)
var <- list(DBH = "DBH")

## We'll use the normal probability density function dnorm - add its
## arguments to our parameter list

## "x" value in PDF is observed value
var$x <- "Radius"

## The mean is the predicted value, the outcome of the model statement. Use
## the reserved word "predicted"
var$mean <- "predicted"
var$sd <- 0.815585

## Set bounds within which to search for parameters
par_lo <- list(a = 0, b = 0)
par_hi <- list(a = 50, b = 50)

## Have dnorm calculate log likelihood
var$log <- TRUE

\dontrun{
results <- anneal(model, par, var, crown_rad, par_lo, par_hi, dnorm, "Radius", max_iter=20000)
}

##################
## Do support limits - even though there are a set already in results
##################

\dontrun{
limits <- support_limits(model, results$best_pars, var, crown_rad, dnorm, par_lo, par_hi)
}
}


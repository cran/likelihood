\name{anneal}
\alias{anneal}
\title{Perform Simulated Annealing for Maximum Likelihood Estimation}

\description{
  Performs simulated annealing - a global optimization algorithm - for
  maximum likelihood estimation of model parameters.  Bounded, unbounded, and
  mixed searches can all be performed. See the 
  \link{Simulated Annealing Algorithm} help page for more on how simulated
  annealing is actually performed.
}
\usage{
anneal(model, par, var, source_data, par_lo = NULL, par_hi = NULL, pdf, 
dep_var, initial_temp = 3, temp_red = 0.95, ns = 20, nt = 100, 
max_iter = 50000, min_change = 0, min_drops = 100, hessian = TRUE, 
delta = 100, slimit = 2, note = "", show_display = TRUE, ...)
}
\arguments{
\item{model}{Scientific model for whose parameters \code{anneal} will find
  maximum likelihood estimates. This is an R function.}
\item{par}{List object of parameters for which to find maximum likelihood 
  estimates using simulated annealing. The name of each component in \code{par}
  matches the name of an argument in one of the functions passed to
  \code{anneal} (either \code{model}, \code{pdf}, or any other function that
  you pass in).  The value of each component is the initial value. All
  components in \code{par} must be numeric vectors.  Vectors of length greater
  than one have each of their elements treated separately as individual
  parameters to estimate.}
\item{var}{List object with the source for all other arguments and
  data used by \code{model}, \code{pdf}, and any other functions.}
\item{source_data}{Data frame containing any needed source data. You can 
  reference the data frame columns by name to \code{anneal}.}
\item{par_lo}{List object with the lower search bounds for each parameter to
  estimate.  The list component names and sizes should each match a component
  in \code{par}. Any individual component (up to and including the entire
  \code{par_lo} argument) is optional. For any component of \code{par} that is
  omitted, the lower search bound for that parameter is assumed to be negative
  infinity. (Infinity isn't quite infinity - see details section for more.)}
\item{par_hi}{List object with the upper search bounds for each parameter to
  estimate.  The list component names and sizes should each match a component
  in \code{par}. Any individual component (up to and including the entire
  \code{par_hi} argument) is optional.  For any component of \code{par} that is
  omitted, the upper search bound for that parameter is assumed to be infinity.
  (Infinity isn't quite infinity - see details section for more.)}
\item{pdf}{Probability density function to use in likelihood calculations.
  \code{anneal} depends on a log likelihood value, so you must instruct
  \code{pdf} to calculate the log of its result.  This is an option with all of
  R's built-in PDFs.}
\item{dep_var}{The name of the column in \code{source_data}, as a string, that
  contains the dependent variable (the \dQuote{observed} value).}
\item{initial_temp}{The temperature at which to start the annealing process.}
\item{temp_red}{The rate of temperature reduction (a fractional number less
  than 1).}
\item{ns}{Number of iterations between changes in parameter search ranges. One
  iteration varies all parameters one time.}
\item{nt}{Controls number of iterations between drops in temperature. Temperature
  drops occur at nt * ns iterations. One iteration varies all parameters one time.}
\item{max_iter}{Maximum number of iterations to perform. One iteration varies
  all parameters one time.}
\item{min_change}{An alternate (and optional) way to specify quitting
  conditions for the run. This is the minimum amount of change in likelihood
  in \code{min_drop} number of temperature drops.  If the change is less than
  \code{min_change}, execution stops even if \code{max_iter} number of
  iterations have not been performed.}
\item{min_drops}{The companion to \code{min_change} for alternate quitting
  conditions.  This is the number of temperature drops over which the
  likelihood must have changed more than \code{min_change} for execution to
  continue.}
\item{hessian}{if TRUE, the Hessian matrix is used to calculate the standard
  error for each parameter and the parameter variance-covariance matrix. These
  are included in the output.  If FALSE, this step is skipped.}
\item{delta}{The number by which to divide each parameter maximum likelihood   
  estimate value when searching for support limits. The bigger the number, the 
  finer the search. See \code{\link{support_limits}} for more on how support
  limits are calculated.}
\item{slimit}{When calculating support limits for the parameter maximum
  likelihood estimates, this is the number of likelihood units less than the
  optimum likelihood for which to search the parameter ranges. 2 units is 
  standard.  1.92 units corresponds roughly to a 95 percent confidence 
  interval.}
\item{note}{A note about the run.  This can be any character string.  This 
  will be written to output files by \code{\link{write_results}}.}
\item{show_display}{Whether or not to show the progress display.}
\item{\dots}{Any other data needed by \code{model}, \code{pdf}, or any other
  function to be called by \code{anneal}.  This is an alternative to providing
  the data in \code{var}; however, passing all values in \code{var} is strongly
  recommended.}
}

\value{
A list object with information on the annealing run.  If you stop the run by
pressing Esc, you will get this data structure with the results of the run at
the point where you stopped it.

\item{best_pars}{The maximum likelihood estimates for each value in
  \code{par}.}
\item{var}{A copy of the \code{var} argument, to help you keep track of your
  analysis. To save space, any data frames are removed.}
\item{source_data}{A copy of the \code{source_data} data frame, with a column
  added for the predicted values calculated by \code{model} using the maximum
  likelihood estimates of the parameters.}
\item{pdf}{The name of the \code{pdf} function.}
\item{model}{The name of the \code{model} function.}
\item{iterations}{The number of annealing iterations completed.  One iteration
  varies all parameters one time.  If the run does not complete, this may not
  be an integer.}
\item{max_likeli}{The maximum likelihood value found.}
\item{aic_corr}{The value of Akaike's Information Criterion, \dQuote{corrected}
  for small sample size. See the \link{Simulated Annealing Algorithm} help page
  for more.}
\item{aic}{The value of Akaike's Information Criterion. See the
  \link{Simulated Annealing Algorithm} help page for more.}
\item{slope}{Slope of observed values linearly regressed on those predicted by
  \code{model}, using the parameter maximum likelihood estimates. The intercept
  is forced at zero.}
\item{R2}{Proportion of variance explained by the model relative to that
  explained by the simple mean of the data.}
\item{likeli_hist}{Data frame with the history of likelihood change throughout
  the run. All changes in likelihood are recorded, along with regular periodic
  checkpoints. The columns are: \dQuote{temp}, the temperature at that point,
  \dQuote{iter}, the number of iterations completed, and \dQuote{likeli}, the
  maximum likelihood value.}
\item{par_lo}{List object with the lower bounds for each of the parameters. If
  any value was omitted in the original arguments, it is recorded here as a
  value that approximates negative infinity.}
\item{par_hi}{List object with upper bounds for varying parameters. If
  any value was omitted in the original arguments, it is recorded here as a
  value that approximates infinity.}
\item{par_step}{List object with final size of the search range for each
  parameter.}
\item{note}{The value of the \code{note} argument, above.}
\item{upper_limits}{List object with upper support limits for each parameter.
  For more on support limits, see the \code{\link{support_limits}} function.}
\item{lower_limits}{List object with lower support limits for each parameters.
  For more on support limits, see the \code{\link{support_limits}} function.}
\item{std_errs}{If \code{anneal} was run with \code{hessian = TRUE}, this is
  a list object with the standard errors for each parameter.}
\item{var_covar_mat}{If \code{anneal} was run with \code{hessian = TRUE}, this
  is the parameter variance / covariance matrix.}
}

\details{
  Simulated annealing is a search algorithm that attempts to find the global
  maximum of the likelihood surface produced by all possible values of the
  parameters being estimated.  The value of the maximum that \code{anneal} finds
  is the maximum likelihood value, and the value of the parameters that produced
  it are their maximum likelihood estimates.  See the
  \link{Simulated Annealing Algorithm} page for details on how the search is
  performed. See the \link{Likelihood Calculation} page for details on how
  likelihood is calculated.  Simulated annealing is an algorithm that can 
  search any function; but \code{anneal} specifically searches likelihood.

  The \code{model} function is the scientific model, which generally takes as
  arguments the parameters for which to estimate maximum likelihood.  It 
  returns a predicted value of the dependent variable for each record in the
  \code{source_data} dataset, which is compared to the actual (observed) value
  when likelihood is calculated.  Write \code{model} so that it returns a
  vector of numeric values, one for each record in the dataset.

  The probability density function calculates the likelihood using the
  predicted and observed values of the dependent variable.  You can provide 
  your own function, but R has many built-in functions that you can use.  You 
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
  \code{anneal} can be the results of other functions.  \code{anneal}
  will make sure these functions are evaluated at each search iteration.

  \code{anneal} handles all function calls and data.  You tell \code{anneal}
  how to use your functions and data using \code{par} and \code{var}.
  Use \code{par} to give \code{anneal} the list of parameters for which to
  find maximum likelihood estimates.  All values must be numeric vectors.  The
  name of each list component must match the function argument where the
  value should go.  For example, if your model function takes an argument 
  called \dQuote{a}, and you want the maximum likelihood estimate for a, there 
  should be a \code{par$a}.  If any component of \code{par} is a vector of 
  length greater than one, each value is treated as a separate parameter to 
  estimate.  This is useful if, for example, you wish to estimate a parameter 
  that has a different value for different sites or species.

  Use \code{var} to tell \code{anneal} where all other functions and data come
  from.  \code{var} is a list, and each component's name matches the function
  argument it should be used for (as with \code{par}).  The value can be of any
  data type that makes sense to the function.  To indicate that the source of a
  function argument is a column of data from a dataset, set that value of
  \code{var} to the name of the data frame's column, as a character string (for
  example, \code{var$dbh<-"DBH"}).  Case matters!  You will get the best
  results if all function arguments and column names are unique, so that there
  is no ambiguity. You are also free to reference values directly from the global environment in your functions if you prefer.

  The reserved character string \dQuote{predicted}, used in \code{var}, means
  the predicted value of the dependent variable, as calculated by \code{model}.

  If you want \code{anneal} to pass the results of another function as an
  argument to the \code{model} or \code{pdf} functions, define the function
  and then set the appropriate argument in \code{var} to the name of the
  function.  Then provide all arguments to the sub-function in \code{var} as
  well.  For instance, if your model function takes an argument called
  \code{x}, and you wish \code{x} to be the result of function \code{fun1},
  then set \code{var$x <- fun1}, and add any arguments to \code{fun1} to
  \code{var}.  \code{anneal} will ensure that all functions are evaluated in 
  the proper order.

  If the likelihood is calculated as infinity or NaN (which can easily
  happen), the likelihood is arbitrarily set to -1000000 to preserve the
  ability to graph results and compare values.  If your best likelihood is 
  -1000000, it is possible that no valid likelihood value was found.

  The search ranges for parameters can be set to (or allowed to default to)
  negative and positive infinity. In practice, the search is bounded by the
  largest and smallest values the computer can work with.  To find out what the
  actual limits are on your computer, use \code{.Machine$double.xmax}.

  When looking at the examples provided in the demos that come with this
  package, check those for \code{likeli} as well, since the parameter setup
  techniques are the same.
}

\references{
  Goffe, W.L., G.D. Ferrier, and J. Rogers. 1994.  Global optimization of
  statistical functions with simulated annealing.  Journal of Econometrics
  60:65-99.
}

\examples{
##
## Simulated annealing to maximize log
## likelihood for the following:
## Model: Radius = a + b * DBH
## Dataset: included crown_rad dataset
## We want to use simulated annealing to
## find maximum likelihood estimates of
## the parameters "a" and "b".
##
\dontrun{
library(likelihood)

## Set up our dataset
data(crown_rad)
dataset <- crown_rad

## Create our model function
modelfun <- function (a, b, DBH) {a + b * DBH}

## Create the list for the parameters to estimate and
## set initial values for a and b
par <- list(a = 0, b = 0)

## Create a place to put all the other data needed by
## the model and PDF, and indicate that DBH comes from 
## the column marked "DBH" in the dataset
var <- list(DBH = "DBH")

## Set bounds and initial search ranges within which to search for parameters
par_lo <- list(a = 0, b = 0)
par_hi <- list(a = 50, b = 50)

## We'll use the normal probability density function -
## add the options for it to our parameter list
## "x" value in PDF is observed value
var$x <- "Radius"

## Mean in normal PDF
var$mean <- "predicted"
var$sd <- 0.815585

## Have it calculate log likelihood
var$log <- TRUE

results<-anneal(model = modelfun, par = par, var = var,
  source_data = dataset, par_lo = par_lo, par_hi = par_hi,
  pdf = dnorm, dep_var = "Radius", max_iter = 20000)

## Alternately: reference crown_rad$DBH directly in the function without
## using var
modelfun <- function (a, b) {a + b * crown_rad$DBH}
var <- list(x = "Radius",
            mean = "predicted",
            sd = 0.815585,
            log = TRUE)
results<-anneal(model = modelfun, par = par, var = var,
  source_data = dataset, par_lo = par_lo, par_hi = par_hi,
  pdf = dnorm, dep_var = "Radius", max_iter = 20000)  
}  
}

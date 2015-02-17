\name{Simulated Annealing Algorithm}
\alias{Simulated Annealing Algorithm}
\title{Details on the Simulated Annealing Algorithm}

\description{This gives details on how the simulated annealing process is performed.}

\details{
When you are using likelihood methods to select the best parameter values for a scientific model, you need a method for searching the space of all possible values to find the global maximum likelihood. There are several search algorithms, and many R implementations of them. The simulated annealing algorithm is a good choice for maximizing likelihood for two reasons. The likelihood function is difficult to analyze using mathematical methods, such as derivation. Also, it often has a complex topology in parameter space, with local maxima, cliffs, ridges, and holes where it is undefined. Simulated annealing is an algorithm designed to deal with these problems. The algorithm of course can be applied to all kinds of problems, but its implementation in this package is for analyzing the likelihood function only.

An analogy for the search process is walking a mountain range in the dark, trying to find the highest mountain. In the beginning, when the algorithm's \dQuote{temperature} is high, the search is energetic. In addition to moving uphill, it will also regularly move downhill to try to find a better uphill path. It will also jump off the mountain it's currently on to see if it lands on another, higher mountain. Later in the search, when the temperature and energy are lower, the algorithm works on reaching the top of the best mountain it has found. It may still move downhill to try to find a better path to the top but this becomes less and less likely. 

The search (hopefully) ends with the algorithm converging on the global maximum. This may happen quickly or may take a very long time. The algorithm cannot know when it has found the global maximum, so it continues searching until it reaches a predefined end point, and leaves it up to you to judge the result. The set of search controls is called the annealing schedule, and defines the search's initial conditions, its rate of energy drop, and its end point. You can change this schedule to maximize the probability of convergence with the minimum amount of computation time.

You begin an annealing run by setting up the annealing schedule and the parameter search space. For the annealing schedule, you provide: 

\itemize{
  \item{Initial temperature (\var{t}).}{ The higher the temperature, the more energetic the search.}
  \item{Rate of reduction in temperature (\var{rt}).}{ This controls how quickly the temperature falls throughout the run.}
  \item{Rate of drops in temperature (\var{nt}).}{ This controls how long the search stays at a certain temperature before further cooling.}
  \item{Interval between changes in range (\var{ns}).}{ This controls how often the annealing process adjusts the parameter search range.}
\item{An end point to the search.}{ This is generally a maximum number of search iterations.}
}

For the parameters, you provide:
\itemize{
\item{Initial values.}{ The values whose likelihood is the point where the search starts.} 
\item{Upper and lower bounds.}{ If desired or mathematically necessary. The annealing can also conduct a global search on one or more parameters.}
}

Simulated annealing searches by randomly varying one parameter value, keeping all the other parameter values the same, and calculating the new likelihood. It compares this value to the last likelihood calculated to decide whether to keep the new parameter value or discard it. It then repeats this process by randomly varying the next parameter in the set. When each parameter has been varied one time, that is one search iteration. Simulated annealing then starts over with the first parameter again, beginning a new iteration.

The latest set of parameter values represents the point in the search space where the algorithm is on its current path. The algorithm also keeps a copy of the values that produced the highest likelihood yet found, so it can go back to that point.

Each time simulated annealing picks a new parameter value to test, it must decide whether to accept or reject the change. First, it compares the new parameter's likelihood value to the likelihood before the change. If the new value is equal to or greater than the previous value, the change in the parameter is accepted and the algorithm takes a step uphill. It then checks to see if it's at a new overall high point in the search. If so, it saves this set of parameter values as its best yet.
 
If the new parameter value's likelihood is worse than the previous one (representing a step downhill), simulated annealing uses the Metropolis criterion to decide whether or not to accept the move. The criterion is:

\deqn{p = e^{-\frac{L1 - L2}{t}}}{p = exp(L1 - L2)/T}

where \var{p} is the probability the move will be accepted, \var{L1} is the previous likelihood, \var{L2} is the new likelihood, and \var{T} is the current annealing temperature. The algorithm compares a random number to this probability. If the move is accepted, the algorithm steps downhill. If the move is rejected, the new parameter value is discarded and the search stays in the same place, to try a step in a different direction with the next parameter.

The parameter values are randomly chosen within a range. The search begins with any defined upper and lower bounds, or infinity if there are none. Every \var{ns} iterations (where \var{ns} is the interval between changes in range in the initial annealing schedule), simulated annealing adjusts its search bounds for each parameter so that 50\% of all moves will be accepted, either enlarging the bounds to find new ground to search or shrinking them to narrow in on a maximum. 

After \var{ns} * \var{nt} iterations, the temperature \var{T} drops as 

\deqn{T'= rt * T}

where \var{rt} is the rate of temperature reduction given in the initial annealing schedule.

The search ends when simulated annealing has reached the end point defined in its annealing schedule; either a maximum number of iterations, or a failure to find a higher likelihood within a set amount of temperature drop. The search may end before the global maximum has been reached.

\strong{Using the algorithm}

You set up the annealing schedule and search bounds to maximize the probability of convergence on the global maximum while minimizing the computation time. Unfortunately, there are no firm rules for establishing that convergence has occurred. You can conclude that the algorithm has not converged if the maximum likelihood is still trending upwards when the run ends. If the maximum likelihood is stable for many iterations, this is evidence for convergence. Better evidence is multiple runs finding approximately the same maximum likelihood.

If an annealing run has not converged by the time it finishes, you can change the annealing schedule to improve the chances of convergence on a subsequent run. If the likelihood is changing at a rapid rate when the run finishes, give it more time by increasing the maximum iterations, and possibly increasing \var{ns} and \var{nt} as well. You can also begin subsequent runs by setting the parameter initial values to the best values found in the previous run, to allow it to continue searching where it left off.

If the maximum likelihood value does not change much throughout the run, but the maximum likelihood estimates for the parameters are not very good and you suspect that better values exist but were not found, it's possible the run was not effectively searching the parameter space. Try increasing the parameter bounds and the initial temperature to start a more energetic search.

\strong{Other information calculated}

The simulated annealing algorithm returns many pieces of information to allow evaluation of the maximum likelihood estimates and comparison between models.

\bold{Akaike's Information Criterion.} Akaike's Information Criterion is a measure of how well a model approximates reality. Its most common use is to compare models (based on the same dataset) that differ in their number of parameters.  Models with more parameters will generally have higher likelihood, and AIC provides a means to incorporate principles of parsimony in model comparison.

AIC is calculated as:

\deqn{AIC = -2 ln(L(\theta | y)) + 2K}

where \eqn{ln(L(\theta|y))} is the log likelihood and \var{K} is the number of model parameters.

Unless the sample size is large relative to the number of model parameters, AIC corrected for small sample size (AICc) is recommended as an alternative. This is calculated as:

\deqn{AIC_{c} = -2ln(L(\theta|y))+2K(\frac{n}{n-K-1})}{AICc = -2 ln(L(\theta | y)) + 2K(n/(n-K-1))}
 
where \var{n} = dataset size.

\bold{Slope}. Slope is calculated as:
 
\deqn{slope=\frac{\sum_{i=1}^{N}(obs_i)(exp_i)}{\sum_{i=1}^{N}exp_i^2}}{slope = \sum(i=1\dots N) (obsi * expi) / \sum(i=1\dots N) expi^2}

where \eqn{exp_i}{expi} is the expected value of observation i in the dataset (\eqn{obs_i}{obsi}) given the model.

\bold{R2.}  \eqn{R^2}{R2} (different from \eqn{r^2}{r2}) is the proportion of variance explained by the model relative to that explained by the simple mean of the data. It is not bounded between 0 and 1. It is calculated as:

\deqn{R^2 = 1-\frac{SSE}{SST} = 1 - \frac{\sum_{i=1}^{N}(obs_{i}-exp_{i})^2}{\sum_{i=1}^{N}(obs_{i}-\overline{obs})^2}}{R2 = 1 - SSE/SST = 1 - [\sum(i=1\dots N) (obsi - expi)^2 \ \sum(i=1\dots N) (obsi - mean(obs))^2]}

 
where \eqn{exp_i}{expi} is the expected value of observation i in the dataset (\eqn{obs_i}{obsi}) given the model, and \eqn{\overline{obs_i}}{mean(obs)} is the mean of the observations.

\bold{Support limits.} Support limits help you evaluate the strength of support for each parameter's maximum likelihood estimate. For details on how support limits are calculated, see the help page for the \code{\link{support_limits}} function.

\bold{Standard errors, variance and covariance.} Standard errors are calculated using the Hessian matrix, which is a matrix of numerical approximations of the second partial derivatives of the likelihood function with respect to parameters, evaluated at the maximum likelihood estimates. Inverting the negative of the Hessian matrix gives the parameter variance-covariance matrix. The square roots of the diagonals of the variance-covariance matrix are the parameter standard errors.
}

\references{
  Goffe, W.L., G.D. Ferrier, and J. Rogers. 1994.  Global optimization of
  statistical functions with simulated annealing.  Journal of Econometrics
  60:65-99.
}

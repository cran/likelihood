\name{Likelihood Calculation}
\alias{Likelihood Calculation}
\title{Details on the Calculation of Likelihood}

\description{
There are four inputs to a likelihood calculation: a scientific model, a probability model, parameters for the model, and data. The scientific model mathematically describes one or more relationships that have been captured by the data. The probability model describes the error in the data. The parameters are the variables of interest for the scientific and probability models, for which you are trying to find the best values.
 
The dataset contains a dependent variable of interest. The values for this variable in the dataset are the \dQuote{observed} values. The scientific model predicts values for this same dependent variable, based on other data and parameters. The values produced by the scientific model for the dependent variable are the \dQuote{predicted} values. The differences between the observed and predicted values are the residuals.

The probability model is the core of likelihood estimation. Given the scientific model and a set of specific values for its parameters, there is a certain probability of observing the actual data. The mathematical relationship that describes that probability is the probability density function. This PDF is used to calculate the likelihood of the specific parameter values, given the data.

In order to do a likelihood calculation, you must identify your scientific model, choose a probability density function, and choose values for each of your parameters. To help you identify these pieces, here is an example. Suppose research is being conducted to study how cold weather affects sales at coffee shops. A dataset is gathered, with outdoor temperature and number of coffees sold. The researcher proposes that the number of coffees sold is a linear function of the outdoor temperature. The scientific model is:

\deqn{Sales = a + b * Temp}

The observed values for the dependent variable (coffee sales) are the sales data gathered. The parameters are a and b. Once test values have been chosen for a and b, we can calculate the likelihood of those values. To calculate the likelihood, the test values of a and b, along with the temperature data, are plugged into the scientific model, which gives us a set of predicted values for sales.

The error, the difference between the predicted and observed values, is described by the probability model. In our example, we will assume that the error is normally distributed. The normal probability distribution function is then the probability model. The probability model compares the predicted and observed values to produce the final likelihood.

If we repeat the likelihood calculation with another set of values for a and b, we can compare the two likelihood values. The values that produce the higher likelihood value are better. The values that produce the best likelihood possible are the maximum likelihood estimates for those parameters.

\strong{Details}

For eqn{i = 1\dots N} independent observations in a vector \var{X}, with individual observations \eqn{x_i}{xi}, and a set of parameter values \eqn{\theta}:

\deqn{Likelihood=L(\theta|X)=\prod_{i=1}^{N}g(x_i|\theta)}{Likelihood = L(\theta | X) = \prod(i=1\dots N) g(xi | \theta))} 

where \eqn{L(\theta | X)} is the likelihood of the set of parameters \eqn{\theta} given the observations \var{X}, and \eqn{g(x_i|\theta)}{g(xi | \theta)} is the probability density function of the probability model (i.e. the probability of each observation, given the parameters). Because logarithms are easier to work with, the preferred value is log likelihood, calculated as:

\deqn{Log likelihood=ln[L(\theta|X)] = \sum_{i=1}^{N}ln[g(x_i|\theta)]}{Log likelihood = ln[L(theta | X] =\sum(i=1\dots N) ln[g(xi | theta)])}

Thus to calculate likelihood, we use the parameter values and the scientific model to calculate a set of predicted values for each of the observed values in the dataset. Then we use the probability density function to calculate the natural log of the probability of each pair of predicted and observed values. Then we sum the result over all observations in the dataset. For each data point, the mean of the probability density function is the observed value. The point for which the probability is being calculated, given that mean (generally called \dQuote{x} in R's PDFs), is the predicted value.

}


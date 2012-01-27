\name{predicted_results}
\alias{predicted_results}
\title{Calculate Model Predicted Results}

\description{
  Calculate predicted results of the dependent variable from a model with 
  parameters set up as for the \code{\link{likeli}} and \code{\link{anneal}}
  functions. These predicted results are useful for various statistical
  calculations when compared to observed results from a dataset.
}
\usage{
predicted_results(model, par, var, source_data, ...)
}
\arguments{
\item{model}{Model function to use to calculate predicted results.}
\item{par}{List of parameters for which likelihood is being estimated.
  All elements in \code{par} must be numeric vectors.}
\item{var}{List object with the source for all other non-parameter arguments
 and data used by \code{model}, \code{pdf}, or any sub-functions.}
\item{source_data}{Data frame containing any needed source data.}
\item{\dots}{Any other data that may be needed by the model or any of its
  sub-functions.  This is an alternative to providing the data in \code{var};
  however, passing values in \code{var} is strongly recommended.}
}

\value{
  A vector of predicted results, one for each observation in
  \code{source_data}.
}

\details{
  The parameters for this function are set up exactly as they are in
  \code{\link{anneal}} and \code{\link{likeli}}.  See those pages for details
  on how to do this.

  Extra list members in \code{var} are ignored, so if
  you have set up a \code{var} list for use with \code{\link{likeli}} or
  \code{\link{anneal}}, you can use that list with \code{predicted_results}
  without removing arguments for the PDF.
}

\examples{
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

predicted <- predicted_results(model, par, var, crown_rad)

## Calculate R2 - proportion of variance explained by the model relative to 
## that explained by the simple mean of the data
meanrad <- mean(crown_rad$Radius)
sse <- (crown_rad$Radius - predicted)^2
sst <- (crown_rad$Radius - meanrad)^2
R2 <- 1 - (sum(sse)/sum(sst))
}


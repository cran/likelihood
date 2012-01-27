\name{write_results}
\alias{write_results}
\title{Write the Results of Simulated Annealing to File}

\description{
  Takes the results produced by the function \code{\link{anneal}} and
  writes them to a tab-delimited text file.
}
\usage{
write_results(results, filename, data = TRUE, print_whole_hist = FALSE)
}
\arguments{
\item{results}{The output list produced by the function 
  \code{\link{anneal}}.}
\item{filename}{A string with the file and path to the file you wish to write.
  This will overwrite any existing files of that name.  This will not add any
  file extensions so remember to put on the appropriate one.} 
\item{data}{If TRUE, the \code{source_dataset} member of \code{results} is 
  written to the file; if FALSE, it is not. Large datasets can inflate the
  size of output files.}
\item{print_whole_hist}{If TRUE, the entire likelihood history of the run is printed; if FALSE, it is not. Long runs can have rather long histories.}
}

\value{
A file with the contents of \code{results} written as tab-delimited text.
}

\seealso{
  \code{\link{anneal}}
}

\examples{
## Assuming you have performed a simulated annealing run and placed the 
## results in an object called "my_results"...
\dontrun{write_results(my_results, "c:\\results.txt")}
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tramoseats.R
\name{refresh}
\alias{refresh}
\alias{tramo_refresh}
\alias{tramoseats_refresh}
\title{Refresh a specification with constraints}
\usage{
tramo_refresh(
  spec,
  refspec = NULL,
  policy = c("FreeParameters", "Complete", "Outliers_StochasticComponent", "Outliers",
    "FixedParameters", "FixedAutoRegressiveParameters", "Fixed"),
  period = 0,
  start = NULL,
  end = NULL
)

tramoseats_refresh(
  spec,
  refspec = NULL,
  policy = c("FreeParameters", "Complete", "Outliers_StochasticComponent", "Outliers",
    "FixedParameters", "FixedAutoRegressiveParameters", "Fixed", "Current"),
  period = 0,
  start = NULL,
  end = NULL
)
}
\arguments{
\item{spec}{the current specification to be refreshed ("result_spec")}

\item{refspec}{the reference specification used to define the domain considered for re-estimation ("domain_spec")
By default this is the \code{"TRFull"} or \code{"RSAFull"} specification.}

\item{policy}{the refresh policy to apply (see details)}

\item{period, start, end}{to specify the span on which outliers will be re-identified when \code{policy} equals to \code{"Outliers"}
or \code{"Outliers_StochasticComponent"}. Span definition: \code{period}: numeric, number of observations in a year (12,4...). \code{start}: vector
indicating the start of the series in the format c(YYYY,MM). \code{end}: vector in the format c(YYYY,MM) indicating the date from which outliers
will be re-identified. If span parameters are not specified outliers will be re-detected on the whole series.}
}
\value{
a new specification, an object of class \code{"JD3_X13_SPEC"} (\code{spec_x13()}),
\code{"JD3_REGARIMA_SPEC"} (\code{spec_regarima()})
}
\description{
Function allowing to create a new specification by updating a specification used for a previous estimation.
Some selected parameters will be kept fixed (previous estimation results) while others will be freed for re-estimation
in a domain of constraints. See details and examples.
}
\details{
The selection of constraints to be kept fixed or re-estimated is called a revision policy.
User-defined parameters are always copied to the new refreshed specifications. Only the Tramo
(reg-arima pre-adjustment part) is refreshed, but the final ARIMA model handed down to SEATS for the decomposition part
might be changed as a result of the refreshing process.

Available refresh policies are:

\strong{Current}: applying the current pre-adjustment reg-arima model and adding the new raw data points as Additive Outliers (defined as new intervention variables)

\strong{Fixed}: applying the current pre-adjustment reg-arima model and replacing forecasts by new raw data points.

\strong{FixedParameters}: pre-adjustment reg-arima model is partially modified: regression coefficients will be re-estimated but regression variables, Arima orders
and coefficients are unchanged.

\strong{FixedAutoRegressiveParameters}: same as FixedParameters but Arima Moving Average coefficients (MA) are also re-estimated, Auto-regressive (AR) coefficients are kept fixed.
When using Seats for decomposition it avoids a possible re-allocation of roots between the trend and seasonal components,
which might have led to strong revisions.

\strong{FreeParameters}: all regression and Arima model coefficients are re-estimated, regression variables and Arima orders are kept fixed.

\strong{Outliers}: regression variables and Arima orders are kept fixed, but outliers will be re-detected on the defined span, thus all regression and Arima model coefficients are re-estimated

\strong{Outliers_StochasticComponent}: same as "Outliers" but Arima model orders (p,d,q)(P,D,Q) can also be re-identified.
}
\examples{
y<- rjd3toolkit::ABS$X0.2.08.10.M
# raw series for first estimation
y_raw <-window(y,end = 2009)
# raw series for second (refreshed) estimation
y_new <-window(y,end = 2010)
# specification for first estimation
spec_ts_1<-spec_tramoseats("RSAFull")
# first estimation
sa_ts<- tramoseats(y_raw, spec_ts_1)
# refreshing the specification
current_result_spec <- sa_ts$result_spec
current_domain_spec <- sa_ts$estimation_spec
spec_ts_ref <- tramoseats_refresh(current_result_spec, # point spec to be refreshed
  current_domain_spec, #domain spec (set of constraints)
  policy = "FixedAutoRegressiveParameters")
# 2nd estimation with refreshed specification
sa_ts_ref <- tramoseats(y_new, spec_ts_ref)
}
\references{
More information on revision policies in JDemetra+ online documentation:
\url{https://jdemetra-new-documentation.netlify.app/t-rev-policies-production}
}

#' @title Get per capita values 
#' 
#' @description Function retreives population data from worldbank and returns per capita values.
#' 
#' @param countries ISO codes of the countries in the table to be converted into per capita values.
#' 
#' @param data Numeric vector of the values to be devided by the respective population count.
#' 
#' @param year The respective year. Default = last year.
#' 
#' @return A data.frame with the country ISOs and the per capita values.
#'
#' @examples
#'
#' library(fineprintutils)
#' library(wbstats)
#' 
#' @export
per_capita <- function(countries, data, year = as.integer(format(Sys.Date(), "%Y"))-1){
  pop_data <- wbstats::wb(indicator = "SP.POP.TOTL", startdate = year, enddate = year)
  data_pc <- data.frame(country = as.character(countries),
                        value = as.numeric(data))
  data_pc$pop <- pop_data$value[match(data_pc$country, pop_data$iso3c)]
  data_pc$value <- data_pc$value / data_pc$pop
  return(data_pc[,1:2])
}

library(dplyr)
library(httr2)
library(jsonlite)
library(xml2)
library(purrr)

key <- function() {

  Sys.getenv("COCKTAILDB_API_KEY")

}



valid_resources <- function() {

  c(
    "search",
    "lookup",
    "random",
    "randomselection",
    "popular",
    "latest",
    "filter",
    "list"
  )

}



valid_params <- function(resource = NULL) {

  params_by_resource <- list(
    search = c(search = "s",
               first = "f",
               ingredient = "i"),
    lookup = c(id_cocktail = "i",
               id_ingredient = "iid"),
    random = c(),
    randomselection = c(),
    popular = c(),
    latest = c(),
    filter = c(ingredient = "i",
               alcoholic = "a"),
    list = c(category = "c",
             glass = "g",
             ingredient = "i",
             alcoholic = "a")
  )

  if (is.null(resource)) {
    params_by_resource
  } else {
    params_by_resource[[resource]]
  }

}



core_requester <- function(resource, ...) {

  if (!resource %in% valid_resources()) {
    stop(paste0("Please supply a valid resource for the API. One of:\n",
                paste0(valid_resources(), collapse = "\n")))
  }
  resource <- paste0(resource, ".php")

  params <- list(...)


  request("www.thecocktaildb.com/api/json/v2") %>%
    req_url_path_append(key()) %>%
    req_url_path_append(resource) %>%
    req_url_query(!!!params) %>%
    req_perform() %>%
    resp_body_json(simplfyDataFrame = TRUE, flatten = TRUE)

}
json <- core_requester(resource = "search", s = "marg")



search_drinks <- function(search_string) {

  core_requester("search", s = search_string) %>%
    pluck("drinks") %>%
    bind_rows()

}
test <- search_drinks("old")
# why 29 cols but 51 in json response?
# is it bc some are null and bind_rows is dropping?





# api_get_drinks <- function() {
#
#   r <- list_drinks %>%
#     req_perform()
#
#   # encoding guesses are returned as a list
#   # each element is a df with encoding, language, and confidence
#   # sorted in decreasing order of confidence
#   # since only passing one string, take the first element of the list
#   # then get the result with the highest confidence (the first)
#   enc <- stringi::stri_enc_detect(content(r, as = "raw"))[[1]]$Encoding[[1]]
#
#   df <-  content(r, as = "text", encoding = enc) %>%
#     fromJSON(flatten = TRUE) %>%
#     pluck(1)
#
# }
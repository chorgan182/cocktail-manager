
library(googlesheets4)

# Authenticate using token downloaded from service account
### (this is gitignored so the only way the source sheet can be interacted with
###   is if you also have a service account with access to the source sheet)
gs4_auth(path = ".token/service_account.json")

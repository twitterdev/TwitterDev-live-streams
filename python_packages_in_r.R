install.packages('reticulate')
install.packages('dplyr')
install.packages('jsonlite')library('reticulate')
library('dplyr')
library('yaml')
library('jsonlite')

path_to_python <- "/usr/bin/python3"
use_python(path_to_python)

conda_create("tweetenv")
conda_install("tweetenv", "requests", ignore_installed = TRUE)
conda_install("tweetenv", "pandas", ignore_installed = TRUE)
use_condaenv("tweetenv", required = TRUE)

j <- import("json")
r <- import("requests")
pd <- import("pandas")

input <- readline('What handle do you want to get Tweets from? ')

url <- sprintf("https://api.twitter.com/2/tweets/search/recent?query=from:%s", input)
print(url)


bearer_token <- Sys.getenv("BEARER_TOKEN")
headers <- sprintf('{"Authorization": "Bearer %s"}', bearer_token)
header_dict <- j$loads(headers)

response <- r$request("GET", url, headers=header_dict)
print(response$text)

json_data <- fromJSON(response$text, flatten = TRUE)  %>% as.data.frame
View(json_data)

smaller_df <- select(json_data, data.id, data.text)
View(smaller_df)

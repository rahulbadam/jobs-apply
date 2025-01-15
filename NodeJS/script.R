library(httr)
library(jsonlite)

headers <-  c(
  'accept' = 'application/json, text/plain, */*',
  'accept-language' = 'en-GB,en-US;q=0.9,en;q=0.8',
  'content-type' = 'application/json;',
  'cookie' = '_gid=GA1.2.282053414.1736836798; csrftoken=XQs3sUc4rC6dAvGdziF1vRXFwVUHBPr6vEwiSwQAdXihGiOETfJ6DpmD5p5bMh6H; sessionid=ahb5uuz27zdhojisqrvpp4fdp157sdv0; _clck=dabhjr%7C2%7Cfsk%7C0%7C1840; _clsk=3i4xf8%7C1736836806813%7C2%7C1%7Cu.clarity.ms%2Fcollect; _ga=GA1.2.2131162869.1736836796; _ga_0PQL61K7YN=GS1.1.1736855432.2.1.1736856852.0.0.0; _gat_UA-45611607-3=1',
  'origin' = 'https://www.instahyre.com',
  'X-Custom-Origin' = 'https://www.instahyre.com',
  'priority' = 'u=1, i',
  'referer' = 'https://www.instahyre.com/candidate/opportunities/?company_size=0&job_functions=%2Fapi%2Fv1%2Fjob_function%2F3&job_type=0&location=Bangalore&search=true&skills=React.js,rescript,JavaScript',
  'X-Custom-Referer' = 'https://www.instahyre.com/candidate/opportunities/?company_size=0&job_functions=%2Fapi%2Fv1%2Fjob_function%2F3&job_type=0&location=Bangalore&search=true&skills=React.js,rescript,JavaScript',
  'sec-ch-ua' = '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
  'sec-ch-ua-mobile' = '?0',
  'sec-ch-ua-platform' = 'macOS',
  'sec-fetch-dest' = 'empty',
  'sec-fetch-mode' = 'cors',
  'sec-fetch-site' = 'cross-origin',
  'user-agent' = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
  'x-csrftoken' = 'XQs3sUc4rC6dAvGdziF1vRXFwVUHBPr6vEwiSwQAdXihGiOETfJ6DpmD5p5bMh6H'
)

offset <- 0
all_job_ids <- c() 
has_data <- TRUE  

while (has_data) {
  url <- paste0(
    "https://www.instahyre.com/api/v1/job_search?company_size=0&jobLocations=Bangalore&job_functions=3&job_type=0&skills=React.js&skills=rescript&skills=JavaScript&status=0&offset=",
    offset
  )
  
  response <- GET(url, add_headers(.headers = headers))
  
  # Check for response status and content
  if (response$status_code != 200) {
    cat("Failed to fetch data, status code:", response$status_code, "\n")
    break
  }
  
  data <- fromJSON(content(response, "text"))
  
  if (length(data$objects$id) == 0) {
    cat("No more jobs found.\n")
    has_data <- FALSE 
  } else {
    all_job_ids <- c(all_job_ids, data$objects$id)
    offset <- offset + 35  # Increase offset
  }
}

cat("Found job IDs:", length(all_job_ids), "\n")

for (job_id in all_job_ids) {
  cat("Applying to job ID:", job_id, "\n")
  
  body <- jsonlite::toJSON(list(
    id = NULL,
    is_interested = TRUE,
    job_id = job_id,
    is_activity_page_job = FALSE
  ), auto_unbox = TRUE)
  
  response <- POST(
    url = "https://www.instahyre.com/api/v1/candidate_opportunity/apply",
    add_headers(.headers = headers),
    body = body,
    encode = "json"
  )
  
  if (response$status_code == 200) {
    cat("Applied to job ID:", job_id, "Status: Success\n")
  } else {
    cat("Failed to apply to job ID:", job_id, "Status:", response$status_code, "\n")
  }
  Sys.sleep(0.5)  # Sleep to avoid rate limiting
}

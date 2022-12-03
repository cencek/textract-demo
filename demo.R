## Install dependencies if needed
#install.packages("paws")

readRenviron("~/Documents/Credentials/.Renviron")

library(paws)

# PDF Location

bucket <- "mis685-textract-demo"
file <- "textract-demo.pdf"

textract <- paws::textract()

# Import all associated PDF data through Textract
# --------------------------------------------------
analyze_document <- function(bucket, file) {
  
  # Start analyzing the PDF.
  resp <- textract$start_document_analysis(
    DocumentLocation = list(
      S3Object = list(Bucket = bucket, Name = file)
    ),
    FeatureTypes = "TABLES"
  )
  
  # Check that the analysis is done and get the result.
  count <- 0
  while (count < 30 && (!exists("result") || result$JobStatus == "IN_PROGRESS")) {
    Sys.sleep(1)
    result <- textract$get_document_analysis(
      JobId = resp$JobId
    )
    # If the result has multiple parts, get the remaining parts.
    next_token <- result$NextToken
    while (length(next_token) > 0) {
      next_result <- textract$get_document_analysis(
        JobId = resp$JobId,
        NextToken = next_token
      )
      result$Blocks <- c(result$Blocks, next_result$Blocks)
      next_token <- next_result$NextToken
    }
    count <- count + 1
  }
  
  return(result)
}

analysis <- analyze_document(bucket, file)

#-------------------------------------------------------------------------------


results <- unlist(analysis, recursive=FALSE)


flattenedResults <- unlist(analysis)
View(flattenedResults)

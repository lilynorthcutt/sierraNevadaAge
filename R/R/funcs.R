### FUNCTIONS ###
toCamelCase <- function(list){
  #Check first letter is char
  for (word in list){
    if(!grepl("^[a-zA-Z]", substr(word,1,1))){
      stop(paste0(" First letter in col not a letter. Column name:", word))
    }
  }
  
  #Capitalize only first letter each word
  list %<>% # tolower(.) %>% # NOTE - not making everything lowercase as data 
    # names generally are coming concatenated with subsequent words capitalized
    gsub("\\b([a-z])", "\\U\\1", ., perl = TRUE)
  
  # Concatenate strings
  list <- gsub(" ", "", list)
  
  # Make the first letter lowercase
  list <- paste0(tolower(substr(list,1,1)),
                 substr(list, 2, nchar(list)))
  
  return(list)
}


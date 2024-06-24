##################################
### TESTS ###
##################################
test = 1

str1 <- c("hello world", "EXAMPLE INPUT")
str2 <- c("hello world", "EXAMPLE INPUT", "123 hi")
if( toCamelCase(str1) == c("helloWorld", "exampleInput")){
  paste0("Passed Test ", test)
}else{paste0("Failed Test ", test)}

test=test+1
if( toCamelCase(str2) == c("helloWorld", "exampleInput")){
  paste0("Passed Test ", test)
}else{paste0("Failed Test ", test)}

test=test+1
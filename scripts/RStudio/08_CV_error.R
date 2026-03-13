log_files <- paste0("/home/kuba/Desktop/log", 2:10, ".out")

get_cv <- function(file) {
  line <- grep("CV error", readLines(file), value = TRUE)
  as.numeric(sub(".*CV error.*: ([0-9.]+)", "\\1", line))
}

cv_values <- sapply(log_files, get_cv)
K <- 2:10
cv_df <- data.frame(K = K, CV_error = cv_values)
cv_df

plot(cv_df$K, cv_df$CV_error, type = "b", pch = 19, col = "black",
     xlab = "K",
     ylab = "CV error",
     xaxt = "n")
grid()
axis(1, at = cv_df$K, labels = cv_df$K)

min_idx <- which.min(cv_df$CV_error)
points(cv_df$K[min_idx], cv_df$CV_error[min_idx], col = "red", pch = 19, cex = 1.5)
text(cv_df$K[min_idx], cv_df$CV_error[min_idx],
     labels = paste0("K=", cv_df$K[min_idx]),
     pos = 3, col = "red")
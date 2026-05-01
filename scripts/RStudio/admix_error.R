library(ggplot2)

log_files <- paste0("C:/Users/kjlis/Desktop/admix/log", 2:15, ".txt")

get_cv <- function(file) {
  line <- grep("CV error", readLines(file), value = TRUE)
  as.numeric(sub(".*CV error.*: ([0-9.]+)", "\\1", line))
}

cv_values <- sapply(log_files, get_cv)
K <- 2:15
cv_df <- data.frame(K = K, CV_error = cv_values)

min_idx <- which.min(cv_df$CV_error)
min_point <- cv_df[min_idx, ]

png(file="C:/Users/kjlis/Desktop/admix_error.png", width=2300, height=1600, res=250)
ggplot(cv_df, aes(x = K, y = CV_error)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_point(data = min_point,
             aes(x = K, y = CV_error),
             color = "red", size = 3) +
  scale_x_continuous(breaks = cv_df$K) +
  labs(x = "assumed number of subpopulations (K)", y = "cross-validation error") +
  theme_classic(base_size = 14) +
  theme(
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 14),
    axis.title.x = element_text(margin = margin(t = 13), face = "bold"),
    axis.title.y = element_text(margin = margin(r = 13), face = "bold"),
    panel.grid = element_blank(),
    plot.margin = margin(10, 10, 10, 10))
dev.off()

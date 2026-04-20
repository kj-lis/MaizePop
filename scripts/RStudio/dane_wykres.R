library(ggplot2)

dane <- read.csv("C:/Users/kjlis/Desktop/metadane_all.csv", stringsAsFactors = FALSE, sep = ";")

dane$heterotic.group <- factor(dane$heterotic.group, 
                        levels = c("Iodent", "NSS", "Tropical", "SS", "Mix", "Mexicana", "Parviglumis"))

ggplot(dane, aes(x = heterotic.group, fill = heterotic.group)) +
  geom_bar() +
  scale_fill_manual(values = c(
    "Iodent"      = "green3",
    "SS"          = "blue",
    "NSS"         = "red3",
    "Tropical"    = "purple",
    "Mix"         = "gold",
    "Parviglumis" = "cyan3",
    "Mexicana"    = "darkorange"
  )) +
  labs(x = "Group", y = "n") +
  theme_minimal()